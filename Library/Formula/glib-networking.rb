class GlibNetworking < Formula
  desc "Network related modules for glib"
  homepage "https://launchpad.net/glib-networking"
  url "https://download.gnome.org/sources/glib-networking/2.44/glib-networking-2.44.0.tar.xz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/glib-networking/glib-networking_2.44.0.orig.tar.xz"
  sha256 "8f8a340d3ba99bfdef38b653da929652ea6640e27969d29f7ac51fbbe11a4346"

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gettext"
  depends_on "glib"
  depends_on "gnutls"
  depends_on "gsettings-desktop-schemas"

  def install
    # Block installation into top-level HOMEBREW_PREFIX to sandbox & bottle.
    # Will still get installed into HOMEBREW_PREFIX in the expected place in post_install.
    inreplace "configure", "$($PKG_CONFIG --variable giomoduledir gio-2.0)", libexec/"gio/modules"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--with-ca-certificates=#{etc}/openssl/cert.pem"
    system "make", "install"
  end

  def post_install
    # Sandboxing fixes. Resolves users seeing something like this:
    # https://github.com/Homebrew/homebrew/issues/41501#issuecomment-130959611
    gd = HOMEBREW_PREFIX/"lib/gio/modules"
    gd.mkpath
    gios = [
      gd/"giomodule.cache",
      gd/"libgiognomeproxy.a",
      gd/"libgiognomeproxy.la",
      gd/"libgiognomeproxy.so",
      gd/"libgiognutls.a",
      gd/"libgiognutls.la",
      gd/"libgiognutls.so"
    ]

    gios.each { |f| f.unlink if f.exist? }
    cp_r Dir[libexec/"gio/modules/*"], gd
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
