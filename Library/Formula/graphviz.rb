require 'formula'

class Graphviz <Formula
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.26.3.tar.gz'
  md5 '6f45946fa622770c45609778c0a982ee'
  homepage 'http://graphviz.org/'

  depends_on 'pkg-config' => :build
  depends_on 'pango'

  def install
    ENV.x11
    # Various language bindings fail with 32/64 issues.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-codegens",
                          "--with-x",
                          "--without-devil",
                          "--without-smyrna",
                          "--with-digcola",
                          "--with-ipsepcola",
                          "--without-rsvg",
                          "--with-pangocairo",
                          "--without-glitz",
                          "--with-freetype2",
                          "--with-fontconfig",
                          "--without-gdk-pixbuf",
                          "--without-gtk",
                          "--without-gtkgl",
                          "--without-gtkglext",
                          "--without-glade",
                          "--without-gnomeui",
                          "--without-ming",
                          "--without-quartz",
                          "--disable-java",
                          "--disable-ocaml",
                          "--disable-perl",
                          "--disable-php",
                          "--disable-python",
                          "--disable-r",
                          "--disable-ruby",
                          "--disable-sharp",
                          "--disable-swig"
    system "make install"
  end
end
