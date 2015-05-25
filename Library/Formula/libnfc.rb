require 'formula'

class Libnfc < Formula
  homepage 'http://www.libnfc.org/'
  url 'https://bintray.com/artifact/download/nfc-tools/sources/libnfc-1.7.1.tar.bz2'
  sha1 'd77c1408f5e38f24d69778b2ff82f68b2d7bc111'
  head 'https://code.google.com/p/libnfc/'

  bottle do
    revision 2
    sha1 "55ecc37dabd8c848975f3bbf20a8ab7eb191a788" => :yosemite
    sha1 "13c61f303c9a2dc90d316f81ce7c615b8bb0e2f1" => :mavericks
    sha1 "4d9b2216eb876d9a63fe0c0b168b2de0766d0a21" => :mountain_lion
  end

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'

  # Fixes the lack of MIN macro in sys/param.h on OS X which causes the formula not to compile
  # Reported upstream:
  # https://groups.google.com/forum/?fromgroups=#!topic/libnfc-devel/K0cwIdPuqJg
  # Another patch adds support for USB CDC / ACM type serial ports (tty.usbmodem)
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-serial-autoprobe",
                          "--with-drivers=all"
    system "make install"
    (prefix/'etc/nfc/libnfc.conf').write "allow_intrusive_scan=yes"
  end
end

__END__
diff --git a/libnfc/buses/uart.c b/libnfc/buses/uart.c
index 953c126..8078767 100644
--- a/libnfc/buses/uart.c
+++ b/libnfc/buses/uart.c
@@ -74,7 +74,7 @@
 #endif
 
 #  if defined(__APPLE__)
-const char *serial_ports_device_radix[] = { "tty.SLAB_USBtoUART", "tty.usbserial-", NULL };
+const char *serial_ports_device_radix[] = { "tty.SLAB_USBtoUART", "tty.usbserial", "tty.usbmodem", NULL };
 #  elif defined (__FreeBSD__) || defined (__OpenBSD__) || defined(__FreeBSD_kernel__)
 const char *serial_ports_device_radix[] = { "cuaU", "cuau", NULL };
 #  elif defined (__linux__)
diff --git a/libnfc/nfc-internal.h b/libnfc/nfc-internal.h
index 4fa2fc2..bcafe59 100644
--- a/libnfc/nfc-internal.h
+++ b/libnfc/nfc-internal.h
@@ -40,6 +40,15 @@
 
 #include "log.h"
 
+// Patch to compile on OS X
+// Tested on OS X Mountain Lion
+#ifndef MAX
+#define MAX(a,b) (((a) > (b)) ? (a) : (b))
+#endif
+#ifndef MIN
+#define MIN(a,b) (((a) < (b)) ? (a) : (b))
+#endif
+
 /**
  * @macro HAL
  * @brief Execute corresponding driver function if exists.
