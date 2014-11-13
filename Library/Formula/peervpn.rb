require "formula"

class Peervpn < Formula
  homepage "http://www.peervpn.net"
  url "http://www.peervpn.net/files/peervpn-0-040.tar.gz"
  version "0.040"
  sha1 "45f815445a2d654e2da56de965633743d25f3468"

  depends_on "openssl"
  depends_on :tuntap

  patch :DATA if MacOS.version == :snow_leopard

  def install
    # Remove the Linux-only lrt lib from the makefile or else compile = nope.
    inreplace "Makefile", "LIBS+=-lrt -lcrypto -lz", "LIBS+=-lcrypto -lz"
    system "make"
    bin.install "peervpn"
    etc.install "peervpn.conf"
  end

  def caveats; <<-EOS.undent
    To configure PeerVPN, edit:
      #{etc}/peervpn.conf
    EOS
  end

  test do
    system "#{bin}/peervpn"
  end
end

__END__
diff --git a/platform/io.c b/platform/io.c
index 209666a..0a6c2cf 100644
--- a/platform/io.c
+++ b/platform/io.c
@@ -24,6 +24,16 @@
 #if defined(__FreeBSD__)
 #define IO_BSD
 #elif defined(__APPLE__)
+size_t strnlen(const char *s, size_t maxlen)
+{
+        size_t len;
+
+        for (len = 0; len < maxlen; len++, s++) {
+                if (!*s)
+                        break;
+        }
+        return (len);
+}
 #define IO_BSD
 #define IO_USE_SELECT
 #elif defined(WIN32)
