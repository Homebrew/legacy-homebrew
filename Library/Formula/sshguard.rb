require 'formula'

class Sshguard < Formula
  homepage 'http://www.sshguard.net/'
  url 'http://downloads.sourceforge.net/project/sshguard/sshguard/sshguard-1.5/sshguard-1.5.tar.bz2'
  sha1 'f8f713bfb3f5c9877b34f6821426a22a7eec8df3'

  def patches
    [
    # Fix blacklist flag (-b) so that it doesn't abort on first usage.
    # Upstream bug report:
    # http://sourceforge.net/tracker/?func=detail&aid=3252151&group_id=188282&atid=924685
    "https://sourceforge.net/tracker/download.php?group_id=188282&atid=924685&file_id=405677&aid=3252151",
    # Fix EXC_BAD_ACCESS (SIGBUS) in sprintf when list of addresses to block at once
    # overruns buffer (at around 8 addresses, e.g. when restarting and loading blacklist);
    # and avoid ipfw limit by breaking up long address lists.
    # Reported upstream with a similar but less comprehensive patch
    # by Jin Choi on the sshguard-users list:
    # https://sourceforge.net/mailarchive/forum.php?thread_name=1E9730FA-4162-4764-A581-CB82665F7AF0%40me.com&forum_name=sshguard-users
    # It has been over 2 years since then, and no fix is in the sshguard SVN trunk.
    # This patch has also been sent upstream, but it is not clear whether
    # anyone is actively working on the project there.
    DATA
    ]
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-firewall=#{firewall}"
    system "make install"
  end

  def firewall
    MacOS.version >= :lion ? "pf" : "ipfw"
  end

  def log_path
    MacOS.version >= :lion ? "/var/log/system.log" : "/var/log/secure.log"
  end

  def caveats
    if MacOS.version >= :lion then <<-EOS.undent
      Add the following lines to /etc/pf.conf to block entries in the sshguard
      table (replace $ext_if with your WAN interface):

        table <sshguard> persist
        block in quick on $ext_if proto tcp from any to any port 22 label "ssh bruteforce"

      Then run sudo pfctl -f /etc/pf.conf to reload the rules.
      EOS
    end
  end

  plist_options :startup => true

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_prefix}/sbin/sshguard</string>
        <string>-l</string>
        <string>#{log_path}</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
    EOS
  end
end
__END__
--- sshguard-1.5/src/fwalls/ipfw.c.dist	2011-02-09 07:01:47.000000000 -0500
+++ sshguard-1.5/src/fwalls/ipfw.c	2014-02-10 22:38:16.000000000 -0500
@@ -36,7 +36,14 @@
 
 #define IPFWMOD_ADDRESS_BULK_REPRESENTATIVE     "FF:FF:FF:FF:FF:FF:FF:FF"
 
-#define MAXIPFWCMDLEN           90
+/*
+ * ipfw on MacOS 10.6.8 empirically has a command length limit of around 255 bytes,
+ * or 15 ipv4 addresses (not sure which one triggers it).
+ * Longer than that and it fails with
+ * ipfw: getsockopt(IP_FW_ADD): Invalid argument
+ */
+#define MAXIPFWCMDLEN           256
+#define MAX_ADDRESSES_PER_RULE  10 /* be conservative, and watch out for ipv6 addr len */
 
 #ifndef IPFW_RULERANGE_MIN
 #define IPFW_RULERANGE_MIN      55000
@@ -119,19 +126,30 @@
 /* add all addresses in one single rule:
  *
  *   ipfw add 1234 drop ipv4 from 1.2.3.4,10.11.12.13,123.234.213.112 to any
+ * We potentially need to create multiple rules to work around ipfw limitation noted above.
  */
 int fw_block_list(const char *restrict addresses[], int addrkind, const int service_codes[]) {
     ipfw_rulenumber_t ruleno;
     struct addr_ruleno_s addendum;
     int ret;
-
+    int i, j;
+    const char *addresses_safe[MAX_ADDRESSES_PER_RULE + 1];
     
     assert(addresses != NULL);
     assert(service_codes != NULL);
 
+    i = 0;
+    while (addresses[i] != 0) {
+	 /* Break up the addresses list into chunks, as needed. */
+	 j = 0;
+	 while (j < MAX_ADDRESSES_PER_RULE && addresses[i] != 0) {
+	      addresses_safe[j++] = addresses[i++];
+	 }
+	 addresses_safe[j] = 0;
+	
     ruleno = ipfwmod_getrulenumber();
-    /* insert rules under this rule number (in chunks of max_addresses_per_rule) */
-    if (ipfwmod_buildblockcommand(ruleno, addresses, addrkind, command, args) != FWALL_OK)
+    /* insert rules under this rule number */
+    if (ipfwmod_buildblockcommand(ruleno, addresses_safe, addrkind, command, args) != FWALL_OK)
         return FWALL_ERR;
 
     /* run command */
@@ -148,6 +166,7 @@
     addendum.ruleno = ruleno;
     addendum.addrkind = addrkind;
     list_append(& addrrulenumbers, & addendum);
+    }
 
     return FWALL_OK;
 }
@@ -169,15 +188,15 @@
     switch (data.addrkind) {
         case ADDRKIND_IPv4:
             /* use ipfw */
-            sprintf(command, IPFW_PATH "/ipfw");
+            snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ipfw");
             break;
         case ADDRKIND_IPv6:
 #ifdef FWALL_HAS_IP6FW
             /* use ip6fw if found */
-	    	sprintf(command, IPFW_PATH "/ip6fw");
+	    	snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ip6fw");
 #else
             /* use ipfw, assume it supports IPv6 rules as well */
-	    	sprintf(command, IPFW_PATH "/ipfw");
+	    	snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ipfw");
 #endif
             break;
         default:
@@ -218,14 +237,14 @@
             case ADDRKIND_IPv6:
 #ifdef FWALL_HAS_IP6FW
                 /* use ip6fw if found */
-                sprintf(command, IPFW_PATH "/ip6fw");
+                snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ip6fw");
 #else
                 /* use ipfw, assume it supports IPv6 rules as well */
-                sprintf(command, IPFW_PATH "/ipfw");
+                snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ipfw");
 #endif
                 break;
         }
-        sprintf(args, "delete %u", data->ruleno);
+        snprintf(args, MAXIPFWCMDLEN, "delete %u", data->ruleno);
         sshguard_log(LOG_DEBUG, "running: '%s %s'", command, args);
         ret = ipfwmod_runcommand(command, args);
         if (ret != 0) {
@@ -286,6 +305,7 @@
 
 static int ipfwmod_buildblockcommand(ipfw_rulenumber_t ruleno, const char *restrict addresses[], int addrkind, char *restrict command, char *restrict args) {
     int i;
+    size_t used;
 
     assert(addresses != NULL);
     assert(addresses[0] != NULL     /* there is at least one address to block */);
@@ -304,19 +324,19 @@
     switch (addrkind) {
         case ADDRKIND_IPv4:
             /* use ipfw */
-            sprintf(command, IPFW_PATH "/ipfw");
-            sprintf(args, "add %u drop ip", ruleno);
+            snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ipfw");
+            snprintf(args, MAXIPFWCMDLEN, "add %u drop ip", ruleno);
             break;
 
         case ADDRKIND_IPv6:
 #ifdef FWALL_HAS_IP6FW
             /* use ip6fw if found */
-	    	sprintf(command, IPFW_PATH "/ip6fw");
+	    	snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ip6fw");
 #else
             /* use ipfw, assume it supports IPv6 rules as well */
-	    	sprintf(command, IPFW_PATH "/ipfw");
+	    	snprintf(command, MAXIPFWCMDLEN, IPFW_PATH "/ipfw");
 #endif
-            sprintf(args, "add %u drop ipv6", ruleno);
+            snprintf(args, MAXIPFWCMDLEN, "add %u drop ipv6", ruleno);
             break;
 
         default:
@@ -324,11 +344,14 @@
     }
 
     /* add the rest of the rule */
-    sprintf(args + strlen(args), " from %s", addresses[0]);
+    used = strlen(args);
+    snprintf(args + used, MAXIPFWCMDLEN - used, " from %s", addresses[0]);
     for (i = 1; addresses[i] != NULL; ++i) {
-        sprintf(args + strlen(args), ",%s", addresses[i]);
+    	used = strlen(args);
+        snprintf(args + used, MAXIPFWCMDLEN - used, ",%s", addresses[i]);
     }
-    strcat(args, " to me");
+    used = strlen(args);
+    strncat(args, " to me", MAXIPFWCMDLEN - used);
 
     return FWALL_OK;
 }
