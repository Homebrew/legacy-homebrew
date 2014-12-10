require "formula"

class GlibNetworking < Formula
  homepage "https://launchpad.net/glib-networking"
  url "http://ftp.gnome.org/pub/GNOME/sources/glib-networking/2.42/glib-networking-2.42.0.tar.xz"
  sha256 "304dd9e4c0ced69094300e0b9e66cd2eaae7161b9fc3186536d11458677d820d"

  def pour_bottle?
    # This formula installs files directly into the top-level gio modules
    # directory, so it can't be bottled.
    false
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-ca-certificates=#{etc}/openssl/cert.pem"
    system "make install"
  end

  test do
    (testpath/"gtls-test.c").write <<-EOS.undent
      #include <gio/gio.h>

      int main (int argc, char *argv[])
      {
        if (g_tls_backend_supports_tls (g_tls_backend_get_default()))
          return 0;
        else
          return 1;
      }
    EOS

    # From `pkg-config --cflags --libs gio-2.0`
    flags = [
      "-D_REENTRANT",
      "-I#{HOMEBREW_PREFIX}/include/glib-2.0",
      "-I#{HOMEBREW_PREFIX}/lib/glib-2.0/include",
      "-I#{HOMEBREW_PREFIX}/opt/gettext/include",
      "-L#{HOMEBREW_PREFIX}/lib",
      "-L#{HOMEBREW_PREFIX}/opt/gettext/lib",
      "-lgio-2.0", "-lgobject-2.0", "-lglib-2.0", "-lintl"
    ]

    system ENV.cc, "gtls-test.c", "-o", "gtls-test", *flags
    system "./gtls-test"
  end
end
