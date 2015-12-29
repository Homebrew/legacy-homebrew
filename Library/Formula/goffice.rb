class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://developer.gnome.org/goffice/"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.26.tar.xz"
  sha256 "2b8dd0a0f84ef4f6bd32bfdae2b68caa0e41631026a74d04c4d2266512a744bb"

  bottle do
    sha256 "beb06ed579c215072cc7cade91baf1856a89d2bde0f4ad7251dceb05a4e63c65" => :el_capitan
    sha256 "f6d33aba331c66a7937b5f3aa615e1314d62ccd11031d84e654f87e845ef4db2" => :yosemite
    sha256 "e783e34815cf7cb29d1a31356cde42575e95563fa4088dcda380e908549d2fb7" => :mavericks
  end

  head do
    url "https://github.com/GNOME/goffice.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "intltool" => :build
  depends_on "pkg-config" => :build
  depends_on "atk"
  depends_on "cairo"
  depends_on "gettext"
  depends_on "gdk-pixbuf"
  depends_on "gtk+3"
  depends_on "libgsf"
  depends_on "librsvg"
  depends_on "pango"
  depends_on "pcre"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    if build.head?
      system "./autogen.sh", *args
    else
      system "./configure", *args
    end
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <goffice/goffice.h>
      int main()
      {
          void
          libgoffice_init (void);
          void
          libgoffice_shutdown (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgoffice-0.10",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["libgsf"].opt_include}/libgsf-1",
           "-I/usr/include/libxml2",
           "-I#{Formula["gtk+3"].opt_include}/gtk-3.0",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdk-pixbuf"].opt_include}/gdk-pixbuf-2.0",
           "-I#{Formula["atk"].opt_include}/atk-1.0",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
