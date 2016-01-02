class Libhid < Formula
  desc "Library to access and interact with USB HID devices"
  homepage "https://libhid.alioth.debian.org/"
  url "http://distcache.freebsd.org/ports-distfiles/libhid-0.2.16.tar.gz"
  sha256 "f6809ab3b9c907cbb05ceba9ee6ca23a705f85fd71588518e14b3a7d9f2550e5"

  bottle do
    cellar :any
    revision 1
    sha256 "a22388fc2ac89d99ed04449c590b035308a81c8f1a2e80ee68ca64a7e10ced7e" => :el_capitan
    sha256 "4920ff4278cbc288fc8c84ef9b3137d99010ba047d6f072b9a6eccf07588721a" => :yosemite
    sha256 "cda30ad7a75c6a9b156806f398d39afd8288dd7c94c6d06685f8168125906cae" => :mavericks
  end

  depends_on "libusb"
  depends_on "libusb-compat"

  # Fix compilation error on 10.9
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-swig"

    system "make", "install"
  end
end

__END__
--- libhid-0.2.16/src/Makefile.am.org	2014-01-02 19:20:33.000000000 +0200
+++ libhid-0.2.16/src/Makefile.am	2014-01-02 19:21:15.000000000 +0200
@@ -17,7 +17,7 @@ else
 if OS_DARWIN
 OS_SUPPORT_SOURCE = darwin.c
 AM_CFLAGS += -no-cpp-precomp
-AM_LDFLAGS += -lIOKit -framework "CoreFoundation"
+AM_LDFLAGS += -framework IOKit -framework "CoreFoundation"
 else
 OS_SUPPORT =
 endif
--- libhid-0.2.16/src/Makefile.in.org	2014-01-02 19:20:35.000000000 +0200
+++ libhid-0.2.16/src/Makefile.in	2014-01-02 19:21:24.000000000 +0200
@@ -39,7 +39,7 @@ POST_UNINSTALL = :
 build_triplet = @build@
 host_triplet = @host@
 @OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_1 = -no-cpp-precomp
-@OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_2 = -lIOKit -framework "CoreFoundation"
+@OS_BSD_FALSE@@OS_DARWIN_TRUE@@OS_LINUX_FALSE@@OS_SOLARIS_FALSE@am__append_2 = -framework IOKit -framework "CoreFoundation"
 bin_PROGRAMS = libhid-detach-device$(EXEEXT)
 subdir = src
 DIST_COMMON = $(include_HEADERS) $(srcdir)/Makefile.am \
