class Libgsf < Formula
  desc "I/O abstraction library for dealing with structured file formats"
  homepage "https://developer.gnome.org/gsf/"
  url "https://download.gnome.org/sources/libgsf/1.14/libgsf-1.14.35.tar.xz"
  sha256 "8fad55e6782bf72466c6335c6bdcb2552d9da10c655486c699b6464bac2ff847"

  bottle do
    sha256 "775e4b30af0be717cdec1cbd2d17947813307716c1cc459b8f52606809590550" => :el_capitan
    sha256 "0279898c84119cc5099aa38dbaeb4c4d53083f6a0ea83d2dd6ec4ca8c2eaed14" => :yosemite
    sha256 "b810c50c6792546d7e870c3eeedbfe205a95f94365bf82fff78be8dc704423c9" => :mavericks
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
