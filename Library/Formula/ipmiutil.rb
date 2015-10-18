class Ipmiutil < Formula
  desc "IPMI server management utility"
  homepage "http://ipmiutil.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/ipmiutil/ipmiutil-2.9.5.tar.gz"
  sha256 "eb00f0582ee75e1f8d371e398d546ddd7639595b9a0a1f27a84cc6ecb038dbe6"

  bottle do
    cellar :any
    sha1 "463fb38c4ac02170177e043ecddbd0b598bce163" => :yosemite
    sha1 "91da6fd51706e874f8a72249339eb3a7bd22adba" => :mavericks
    sha1 "15a3e15c010478e83bf1aa38f9369329f417220e" => :mountain_lion
  end

  depends_on "openssl"

  # Ensure ipmiutil does not try to link against (disabled) OpenSSL's MD2
  # support. Patch submitted upstream in
  # http://sourceforge.net/p/ipmiutil/mailman/message/33373858/
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--enable-sha256",
                          "--enable-gpl"

    system "make", "TMPDIR=#{ENV["TMPDIR"]}"
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
--- ./configure.bak       2015-02-04 22:15:07.000000000 +0100
+++ ./configure   2015-02-04 22:16:18.000000000 +0100
@@ -20739,7 +20739,7 @@
            echo "Detected HP-UX"
            os=hpux
            MD2_CFLAGS="-DSKIP_MD2"
-           OS_CFLAGS="-DHPUX"
+           OS_CFLAGS="-DHPUX $MD2_CFLAGS"
            OS_LFLAGS=""
            OS_DRIVERS="ipmimv.c"
            drivers="open"
@@ -20748,7 +20748,7 @@
            echo "Detected MacOSX"
            os=macos
            MD2_CFLAGS="-DSKIP_MD2"
-           OS_CFLAGS="-DMACOS"
+           OS_CFLAGS="-DMACOS $MD2_CFLAGS"
            OS_LFLAGS=""
           OS_DRIVERS="ipmimv.c ipmidir.c"
           drivers="open direct"
