require 'formula'

class Graphviz <Formula
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.26.3.tar.gz'
  md5 '6f45946fa622770c45609778c0a982ee'
  homepage 'http://graphviz.org/'

  depends_on 'pkg-config' => :build

  def install
    ENV.x11
    # Various language bindings fail with 32/64 issues.
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-quartz",
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
