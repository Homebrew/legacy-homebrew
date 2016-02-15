class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.36.tar.xz"
  sha256 "71b7507f86c0f7c341bb362bdc7925a2ae286729be0bf5b8fd9581ffbbd62940"

  bottle do
    sha256 "e26bcf9832cb64fe4b98df09c91804d3767cf8917f35dcaeaed91283a1d23d61" => :el_capitan
    sha256 "9fdaabafa3deff19e3ac9d301f76fdd3179b99622d143aa80999919e36a86074" => :yosemite
    sha256 "6fea08afcb32ebe2002155060ce5252b8aa7aed621f72a9bd3f590e1c1c59b00" => :mavericks
  end

  head do
    url "https://github.com/GNOME/libgsf.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "gnome-common" => :build
    depends_on "gtk-doc" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "intltool" => :build
  depends_on "gdk-pixbuf" => :optional
  depends_on "gettext"
  depends_on "glib"

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
    system bin/"gsf", "--help"
    (testpath/"test.c").write <<-EOS.undent
      #include <gsf/gsf-utils.h>
      int main()
      {
          void
          gsf_init (void);
          return 0;
      }
    EOS
    system ENV.cc, "-I#{include}/libgsf-1",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           testpath/"test.c", "-o", testpath/"test"
    system "./test"
  end
end
