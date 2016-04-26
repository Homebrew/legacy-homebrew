class Peervpn < Formula
  desc "Peer-to-peer VPN"
  homepage "https://peervpn.net/"
  url "https://peervpn.net/files/peervpn-0-041.tar.gz"
  version "0.041"
  sha256 "94a7b649a973c1081d3bd9499bd7410b00b2afc5b4fd4341b1ccf2ce13ad8f52"

  bottle do
    cellar :any
    revision 1
    sha256 "415752cdc8aa3e3a53f1456ca1fe9cb8966c74f2a0255309d78b505e7eeae52d" => :mavericks
  end

  depends_on "openssl"
  depends_on :tuntap

  patch :DATA if MacOS.version == :snow_leopard

  def install
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
