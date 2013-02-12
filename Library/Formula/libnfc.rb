require 'formula'

class Libnfc < Formula
  homepage 'http://www.libnfc.org/'
  url 'http://libnfc.googlecode.com/files/libnfc-1.7.0-rc1.tar.gz'
  sha1 'b8660604c950c50c12d68025672bf553e50f111d'

  option 'with-pn532_uart', 'Enable PN532 UART support'

  depends_on 'pkg-config' => :build
  depends_on 'libusb-compat'

  # Fixes the lack of MIN macro in sys/param.h on OS X which causes the formula not to compile
  # Reported upstream:
  # https://groups.google.com/forum/?fromgroups=#!topic/libnfc-devel/K0cwIdPuqJg
  def patches
    DATA
  end

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
    ]

    if build.include? 'with-pn532_uart'
      args << "--enable-serial-autoprobe"
      args << "--with-drivers=pn532_uart"
    end

    system "./configure", *args
    system "make install"
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
