class Libxmlxx3 < Formula
  desc "C++ wrapper for libxml"
  homepage "http://libxmlplusplus.sourceforge.net"
  url "https://download.gnome.org/sources/libxml++/3.0/libxml++-3.0.0.tar.xz"
  sha256 "2ff3640417729d357bada2e3049061642e0b078c323a8e0d37ae68df96547952"

  bottle do
    cellar :any
    sha256 "1eee12f428fea153679ce88eaf7f334f00ceb64aea6cf139346b535c5a664554" => :el_capitan
    sha256 "e068fff70a7513e0225288bc6092f37a016b4269d3a76c3997be1ba5a964c4e9" => :yosemite
    sha256 "8987284c0005cd2b8b80d91b81f13783e4e7d1ebff1f794b4686891381614b1a" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "glibmm"
  # LibXML++ can't compile agains the version of LibXML shipped with Leopard
  depends_on "libxml2" if MacOS.version <= :leopard

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<-EOS.undent
      #include <libxml++/libxml++.h>

      int main(int argc, char *argv[])
      {
         xmlpp::Document document;
         document.set_internal_subset("homebrew", "", "http://www.brew.sh/xml/test.dtd");
         xmlpp::Element *rootnode = document.create_root_node("homebrew");
         return 0;
      }
    EOS
    ENV.libxml2
    gettext = Formula["gettext"]
    glib = Formula["glib"]
    glibmm = Formula["glibmm"]
    libsigcxx = Formula["libsigc++"]
    flags = (ENV.cflags || "").split + (ENV.cppflags || "").split + (ENV.ldflags || "").split
    flags += %W[
      -I#{gettext.opt_include}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -I#{glibmm.opt_include}/glibmm-2.4
      -I#{glibmm.opt_lib}/glibmm-2.4/include
      -I#{include}/libxml++-3.0
      -I#{libsigcxx.opt_include}/sigc++-2.0
      -I#{libsigcxx.opt_lib}/sigc++-2.0/include
      -I#{lib}/libxml++-3.0/include
      -L#{gettext.opt_lib}
      -L#{glib.opt_lib}
      -L#{glibmm.opt_lib}
      -L#{libsigcxx.opt_lib}
      -L#{lib}
      -lglib-2.0
      -lglibmm-2.4
      -lgobject-2.0
      -lintl
      -lsigc-2.0
      -lxml++-3.0
      -lxml2
    ]
    system ENV.cxx, "-std=c++11", "test.cpp", "-o", "test", *flags
    system "./test"
  end
end
