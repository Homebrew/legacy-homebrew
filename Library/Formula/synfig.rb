class Synfig < Formula
  desc "Command-line renderer"
  homepage "http://synfig.org"
  url "https://downloads.sourceforge.net/project/synfig/releases/1.0/source/synfig-1.0.tar.gz"
  sha256 "1f2f9b209d49dff838049e9817b0458ac6987e912a56c061aa2f9c2faeb40720"
  revision 2

  head "git://synfig.git.sourceforge.net/gitroot/synfig/synfig"

  bottle do
    sha256 "d109db84521cd3d8d4092de86bdeda50e96f726616f3c1a50f0bf0912a3a91e3" => :el_capitan
    sha256 "45df75ac729cc20877f89542d25f466d48c62d7aa51a17ca5535469c59973670" => :yosemite
    sha256 "a30a492c69ef50aec2f1e22482d3c4eaef7c5899a43805afe72918c59cff994c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "etl"
  depends_on "libsigc++"
  depends_on "libxml++"
  depends_on "imagemagick"
  depends_on "libpng"
  depends_on "freetype"
  depends_on "cairo"
  depends_on "pango"
  depends_on "boost"
  depends_on "openexr"
  depends_on "mlt"
  depends_on "libtool" => :run

  needs :cxx11

  # bug filed upstream as http://www.synfig.org/issues/thebuggenie/synfig/issues/904
  patch do
    url "https://gist.githubusercontent.com/tschoonj/06d5de3cdc5d063f8612/raw/26fe46b6eedeecdc686b9fd5aac01de9f2756424/synfig.diff"
    sha256 "0ac5b757ba3dda6a863a79e717fc239648c490eac1e643ff275b8ac232a466a3"
  end

  def install
    ENV.cxx11
    boost = Formula["boost"]
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-boost=#{boost.opt_prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <synfig/version.h>
      int main(int argc, char *argv[])
      {
        const char *version = synfig::get_version();
        return 0;
      }
    EOS
    ENV.libxml2
    cairo = Formula["cairo"]
    etl = Formula["etl"]
    fontconfig = Formula["fontconfig"]
    freetype = Formula["freetype"]
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libpng = Formula["libpng"]
    libsigcxx = Formula["libsigc++"]
    libxmlxx = Formula["libxml++"]
    mlt = Formula["mlt"]
    pango = Formula["pango"]
    pixman = Formula["pixman"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{cairo.opt_include}/cairo
      -I#{etl.opt_include}
      -I#{fontconfig.opt_include}
      -I#{freetype.opt_include}/freetype2
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/giomm-2.4
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/giomm-2.4/include
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/synfig-1.0
      -I#{libpng.opt_include}/libpng16
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{libxmlxx.opt_include}/libxml++-2.6
      -I#{libxmlxx.opt_lib}/libxml++-2.6/include
      -I#{mlt.opt_include}
      -I#{mlt.opt_include}/mlt
      -I#{mlt.opt_include}/mlt++
      -I#{pango.opt_include}/pango-1.0
      -I#{pixman.opt_include}/pixman-1
      -D_REENTRANT
      -L#{cairo.opt_lib}
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{libxmlxx.opt_lib}
      -L#{lib}
      -L#{mlt.opt_lib}
      -L#{pango.opt_lib}
      -lcairo
      -lgio-2.0
      -lgiomm-2.4
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lmlt
      -lmlt++
      -lpango-1.0
      -lpangocairo-1.0
      -lpthread
      -lsigc-2.0
      -lsynfig
      -lxml++-2.6
      -lxml2
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
