class Netdiscover < Formula
  desc "ARP Scanner"
  homepage "http://sourceforge.net/projects/netdiscover/"
  url "svn://svn.code.sf.net/p/netdiscover/code/trunk"
  version "0.3-pre-beta7"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gawk" => :build
  depends_on "libnet"

  # In order to get this working on OS X some changes were needed.
  # While I will try to get this accepted upstream, it is not clear
  # if the author is still maintaining this. These changes work against
  # the latest version which is include in Ubuntu and Kali
  # For a discussion of one of the more annoying changes needed for OS X
  # see http://stackoverflow.com/questions/34011043/pcap-not-receiving-traffic-os-x-el-capitan?rq=1
  # Other changes were needed for the LLVM compiler to work right
  patch :DATA

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    chmod 0755, "update-oui-database.sh"
    system "./update-oui-database.sh"
    system "make", "install"
  end

  def caveats; <<-EOS.undent
    Netdiscover suffers from the same issues that are common in wireshark.
    All applications that rely on libpcap running on OS X have permission issues
    with /dev/bpf*. The following caveat from the wireshark formula applies here.

    If your list of available capture interfaces is empty
    (default OS X behavior), try the following commands:

      curl https://bugs.wireshark.org/bugzilla/attachment.cgi?id=3373 -o ChmodBPF.tar.gz
      tar zxvf ChmodBPF.tar.gz
      open ChmodBPF/Install\ ChmodBPF.app

    This adds a launch daemon that changes the permissions of your BPF
    devices so that all users in the 'admin' group - all users with
    'Allow user to administer this computer' turned on - have both read
    and write access to those devices.

    See bug report:
      https://bugs.wireshark.org/bugzilla/show_bug.cgi?id=3760
    EOS
  end

  test do
    # There is no way to test this without further modifying the baseline
    system "true"
  end
end

__END__
diff --git a/src/screen.c b/src/screen.c
index 96b348e..661888a 100644
--- a/src/screen.c
+++ b/src/screen.c
@@ -64,6 +64,9 @@ void init_screen()
    scroll = 0;
    smode = SMODE_HOST;
 
+   blank[0] = ' ';
+   blank[1] = 0x00;
+
    /* Set interative mode options if no parsable mode */
    if(!parsable_output) {
       /* Set signal handlers */
diff --git a/src/ifaces.c b/src/ifaces.c
index a47ec9b..f6bdd03 100644
--- a/src/ifaces.c
+++ b/src/ifaces.c
@@ -86,12 +86,22 @@ void *start_sniffer(void *args)
    datos = (struct t_data *)args;
 
    /* Open interface */
-   descr = pcap_open_live(datos->interface, BUFSIZ, 1, PCAP_TOUT, errbuf);
+   descr = pcap_create(datos->interface, errbuf);
    if(descr == NULL) {
       printf("pcap_open_live(): %s\n", errbuf);
       sighandler(0); // QUIT
    }
 
+   if(pcap_set_immediate_mode(descr, 1) != 0) {
+      printf("pcap_set_immediate_mode(): %s\n", pcap_geterr(descr));
+      sighandler(0); // QUIT
+   }
+
+   if(pcap_activate(descr) != 0) {
+      printf("pcap_activate(): %s\n", pcap_geterr(descr));
+      sighandler(0); // QUIT
+   }
+
    /* Set pcap filter */
    filter = (datos->pcap_filter == NULL) ? "arp" : datos->pcap_filter;
    if(pcap_compile(descr, &fp, filter, 0, 0) == -1) {
@@ -174,6 +174,33 @@ void process_arp_header(struct data_registry *new_reg, const u_char* packet)
             packet[38], packet[39], packet[40], packet[41]);
 }
 
+#ifdef __APPLE__
+#include <sys/socket.h>
+#include <net/if_dl.h>
+
+#include <ifaddrs.h>
+
+int macaddr(char *ifname, char *macaddrstr) {
+    struct ifaddrs *ifap, *ifaptr;
+    unsigned char *ptr;
+
+    if (getifaddrs(&ifap) == 0) {
+        for(ifaptr = ifap; ifaptr != NULL; ifaptr = (ifaptr)->ifa_next) {
+            if (!strcmp((ifaptr)->ifa_name, ifname) && (((ifaptr)->ifa_addr)->sa_family == AF_LINK)) {
+                ptr = (unsigned char *)LLADDR((struct sockaddr_dl *)(ifaptr)->ifa_addr);
+                sprintf(macaddrstr, "%02x:%02x:%02x:%02x:%02x:%02x",
+                                    *ptr, *(ptr+1), *(ptr+2), *(ptr+3), *(ptr+4), *(ptr+5));
+                break;
+            }
+        }
+        freeifaddrs(ifap);
+        return ifaptr != NULL;
+    } else {
+        return 0;
+    }
+}
+#endif
+
 /* Get our mac address */
 void get_mac(char *disp)
 {
@@ -211,6 +238,8 @@ void get_mac(char *disp)
 
   //unsigned char* mac = (unsigned char*) ;
   memcpy(smac, ifr.ifr_hwaddr.sa_data, ETH_ALEN);
+#elif defined(__APPLE__)
+  macaddr(disp, smac);
 #else
    //printf("Unsuported OS\n");
    //exit(1);
diff --git a/update-oui-database.sh b/update-oui-database.sh
old mode 100644
new mode 100755
index 724e1fa..f99b4e4
--- a/update-oui-database.sh
+++ b/update-oui-database.sh
@@ -25,6 +25,6 @@ DATE=$(date +'%Y%m%d')
 ORIGF=oui.txt
 DSTD=src
 DSTF=oui.h
-URL="http://standards.ieee.org/develop/regauth/oui/oui.txt"
+URL="http://standards-oui.ieee.org/oui.txt"
 TMPF=$ORIGF-$DATE
 AWK="gawk"
@@ -78,7 +78,8 @@ echo "Process oui.txt (\"$TMPF\")..."
 
 # if RS is null string, then records are separated by blank lines...
 # but this isn't true in oui.txt

+COUNT=`grep "base 16" $TMPF | wc -l | $AWK '{ print $1; }'`; ((COUNT++))
-LANG=C grep "base 16" $TMPF | sed "s/\"/'/g" | $AWK --re-interval --assign URL="$URL" '
+LANG=C grep "base 16" $TMPF | sed "s/\"/'/g" | sed $'s/\r//g' | $AWK --re-interval -v URL="$URL" -v MYCOUNT="$COUNT" '
 BEGIN {
 	NN = 0;
@@ -95,7 +95,7 @@ BEGIN {
 	  "   char *vendor;   /* Vendor id string     */\n" \
 	  "};\n" \
 	  "\n" \
-	  "struct oui oui_table[] = {\n", strftime("%d-%b-%Y"), URL);
+	  "static struct oui oui_table[%i] = {\n", strftime("%d-%b-%Y"), URL, MYCOUNT);
 }
 
 {
@@ -110,7 +110,6 @@ END {
 	printf("// Total %i items.\n\n", NN);
 }' >"$DSTD/$DSTF"
 
-
 if [ $? -ne 0 ]; then
   echo "$JA: $TMPF parsing error !"
   exit 1
