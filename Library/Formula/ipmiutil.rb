require 'formula'

class Ipmiutil < Formula
  homepage 'http://ipmiutil.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/ipmiutil/ipmiutil-2.8.5.tar.gz'
  sha1 'b79dfddf09d685fb92fba08dd8d1fb8f84adcea9'

  def install

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--enable-sha256", "--enable-gpl",
                          "--prefix=#{prefix}"

    system "make", "TMPDIR=#{ENV['TMPDIR']}"
    system "make",
                   "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  def test
    system "ipmiutil delloem help"
  end

  def patches
    # Make ipmiutil treat Darwin as BSD
    DATA
  end
end

__END__
diff -u ./configure.bak ./configure
--- ./configure.bak	2012-09-18 23:19:11.000000000 +0800
+++ ./configure	2012-09-18 23:21:04.000000000 +0800
@@ -20983,7 +20983,7 @@
 	OS_CFLAGS="-DLINUX $MD2_CFLAGS $cfwarn"
   else
      # usually "x$sysname" = "xFreeBSD", but allow NetBSD
-     echo $sysname | grep BSD >/dev/null 2>&1
+     echo $sysname | grep 'BSD\|Darwin' >/dev/null 2>&1
      if test $? -eq 0; then
 	os=bsd
 	OS_CFLAGS="-DBSD"

