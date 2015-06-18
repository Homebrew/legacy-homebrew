class Goffice < Formula
  desc "Gnumeric spreadsheet program"
  homepage "https://developer.gnome.org/goffice/"
  url "https://download.gnome.org/sources/goffice/0.10/goffice-0.10.22.tar.xz"
  sha256 "0206a87a323b52a874dc54491374245f9e1c5f62e93a2ce4a02fb444a26b0e28"
  revision 1

  bottle do
    sha256 "77844a73d2d543a9f2b3dc9df6e6b9382851927e1e96674e00778cd0eb7b9b18" => :yosemite
    sha256 "ea8509f4242eb3e1903248067b99dfbd4949c805afa20c33899130fdc6958480" => :mavericks
    sha256 "5356db827d669db06a17015ce88cf7c7b1e794183283490422290f903df1629e" => :mountain_lion
  end

  # Fixes a crash with quad precision math when building using clang
  # Will be included in the next release; patch from upstream commit.
  # https://bugzilla.gnome.org/show_bug.cgi?id=749463
  patch do
    url "https://gist.githubusercontent.com/mistydemeo/71c77c48e36116b824b4/raw/2f70e9f1d847bfaea2f328e43b6c8cd0a609902b/goffice.patch"
    sha256 "f51f9a149189c6ab9716716ee0170416c4847739f7bf866fbf388c246008f7e1"
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
