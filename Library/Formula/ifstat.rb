require 'formula'

class Ifstat < Formula
  url 'http://gael.roualland.free.fr/ifstat/ifstat-1.1.tar.gz'
  homepage 'http://gael.roualland.free.fr/ifstat/'
  md5 'b655642c33a626cfe976792fbcd9b6e1'

  def patches
    #Fixes 32/64 bit incompatibility for snow leopard
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make install"
  end
end

__END__
diff --git a/drivers.c b/drivers.c
index d5ac501..47fb320 100644
--- a/drivers.c
+++ b/drivers.c
@@ -593,7 +593,8 @@ static int get_ifcount() {
   int ifcount[] = {
     CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_SYSTEM, IFMIB_IFCOUNT
   };
-  int count, size;
+  int count;
+  size_t size;
   
   size = sizeof(count);
   if (sysctl(ifcount, sizeof(ifcount) / sizeof(int), &count, &size, NULL, 0) < 0) {
@@ -607,7 +608,7 @@ static int get_ifdata(int index, struct ifmibdata * ifmd) {
   int ifinfo[] = {
     CTL_NET, PF_LINK, NETLINK_GENERIC, IFMIB_IFDATA, index, IFDATA_GENERAL
   };
-  int size = sizeof(*ifmd);
+  size_t size = sizeof(*ifmd);
 
   if (sysctl(ifinfo, sizeof(ifinfo) / sizeof(int), ifmd, &size, NULL, 0) < 0)
     return 0;

