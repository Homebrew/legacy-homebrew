class Libnfc < Formula
  desc "Low level NFC SDK and Programmers API"
  homepage "http://www.libnfc.org/"
  url "https://libnfc.googlecode.com/files/libnfc-1.7.0.tar.bz2"
  sha256 "f14df0727c301f9149608dc6e1fbad81ec48372dcd7a364ac1cb805a7a2b2b8b"

  bottle do
    revision 2
    sha256 "76437c13d93466c6f64ebcdee2a8aea6fa54bf129755f368844713a7817b263e" => :el_capitan
    sha256 "80d5a6bb48a2bfe3079689d7b1655c128dbaab946a05528344e284a1bea5173f" => :yosemite
    sha256 "5f63291718ab86e92d0afbaae02fba9b1a2a4d355524d098bc894ffb409b4b6f" => :mavericks
    sha256 "72fde407ef486e39b73f37c92a4d585e47c2e9dad1528c1a40e3ffe0338af6b8" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "libusb-compat"

  # Fixes the lack of MIN macro in sys/param.h on OS X which causes the formula not to compile
  # Reported upstream:
  # https://groups.google.com/forum/?fromgroups=#!topic/libnfc-devel/K0cwIdPuqJg
  # Another patch adds support for USB CDC / ACM type serial ports (tty.usbmodem)
  patch :DATA

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--enable-serial-autoprobe",
                          "--with-drivers=all"
    system "make", "install"
    (prefix/"etc/nfc/libnfc.conf").write "allow_intrusive_scan=yes"
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
+const char *serial_ports_device_radix[] = { "tty.SLAB_USBtoUART", "tty.usbserial-", "tty.usbmodem", "tty.usbserial", NULL };
 #  elif defined (__FreeBSD__) || defined (__OpenBSD__)
 const char *serial_ports_device_radix[] = { "cuaU", "cuau", NULL };
 #  elif defined (__linux__)
