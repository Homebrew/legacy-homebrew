class Libsoup < Formula
  desc "HTTP client/server library for GNOME"
  homepage "https://live.gnome.org/LibSoup"
  url "https://download.gnome.org/sources/libsoup/2.52/libsoup-2.52.1.tar.xz"
  sha256 "0e19bca047ad50b28e8ed7663840f9e45a94909148822ca44dcb3e8cafb5cc48"

  bottle do
    sha256 "420975079715e08fdd2ad1777747ee4fcf314e4d12693a0d2ea17e28e6d21d1d" => :el_capitan
    sha256 "6c15346b36ed1dfac4254a25746bb199a1e03e06bbe1f82f350e7ec4295a69d3" => :yosemite
    sha256 "3b1e564435eb412df49e62dc320fb761fde0305e0a49b443a3218deb6292cbb7" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "glib-networking"
  depends_on "gnutls"
  depends_on "sqlite"
  depends_on "gobject-introspection"
  depends_on "vala"

  def install
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--prefix=#{prefix}",
      "--without-gnome",
      "--disable-tls-check",
    ]

    # ensures that the vala files remain within the keg
    inreplace "libsoup/Makefile.in", "VAPIDIR = @VAPIDIR@", "VAPIDIR = @datadir@/vala/vapi"
    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <libsoup/soup.h>

      int main(int argc, char *argv[]) {
        guint version = soup_get_major_version();
        return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{include}/libsoup-2.4
      -D_REENTRANT
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{lib}
      -lgio-2.0
      -lglib-2.0
      -lgobject-2.0
      -lintl
      -lsoup-2.4
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
