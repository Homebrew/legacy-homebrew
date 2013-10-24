require 'formula'

class Libnfc < Formula
  homepage 'http://www.libnfc.org/'
  url 'https://libnfc.googlecode.com/files/libnfc-1.7.0.tar.bz2'
  sha1 '5adfb6c6238b1659ad8609837dc8e59eb41a8768'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'

  # Fixes the lack of MIN macro in sys/param.h on OS X which causes the formula not to compile
  # Reported upstream:
  # https://groups.google.com/forum/?fromgroups=#!topic/libnfc-devel/K0cwIdPuqJg
  # Another patch adds support for USB CDC / ACM type serial ports (tty.usbmodem)
  def patches
    DATA
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
    (prefix/'etc/nfc/libnfc.conf').write "allow_intrusive_scan=yes"
  end
end

__END__
diff --git a/libnfc/nfc-internal.h b/libnfc/nfc-internal.h
index ec9e2fc..41797b2 100644
--- a/libnfc/nfc-internal.h
+++ b/libnfc/nfc-internal.h
@@ -33,6 +33,15 @@

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
diff --git a/libnfc/buses/uart.c b/libnfc/buses/uart.c
index 7b687c1..686f9ed 100644
--- a/libnfc/buses/uart.c
+++ b/libnfc/buses/uart.c
@@ -46,7 +46,7 @@
 #define LOG_CATEGORY "libnfc.bus.uart"

 #  if defined(__APPLE__)
-const char *serial_ports_device_radix[] = { "tty.SLAB_USBtoUART", "tty.usbserial-", NULL };
+const char *serial_ports_device_radix[] = { "tty.SLAB_USBtoUART", "tty.usbserial-", "tty.usbmodem", NULL };
 #  elif defined (__FreeBSD__) || defined (__OpenBSD__)
 const char *serial_ports_device_radix[] = { "cuaU", "cuau", NULL };
 #  elif defined (__linux__)
