require 'formula'

class Graphviz <Formula
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.26.3.tar.gz'
  md5 '6f45946fa622770c45609778c0a982ee'
  homepage 'http://graphviz.org/'

  depends_on 'pkg-config'

  def install
    # Put freetype-config in path
    ENV.x11
    ENV.prepend 'PATH', "/usr/X11/bin", ":"

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-quartz",
                          "--disable-php",
                          "--disable-perl"
    system "make install"
  end
end
