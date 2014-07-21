require 'formula'

class Ipmiutil < Formula
  homepage 'http://ipmiutil.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-2.9.1.tar.gz'
  sha1 'f23fabe8339842fea9b8c2a601717dc002e44a9d'

  # Make ipmiutil treat Darwin as BSD
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV['TMPDIR']}"
    # DESTDIR is needed to make everything go where we want it.
    system "make", "prefix=/",
                   "DESTDIR=#{prefix}",
                   "varto=#{var}/lib/#{name}",
                   "initto=#{etc}/init.d",
                   "sysdto=#{prefix}/#{name}",
                   "install"
  end

  test do
    system "#{bin}/ipmiutil", "delloem", "help"
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
