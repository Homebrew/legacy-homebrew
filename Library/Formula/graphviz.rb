require 'brewkit'

class Graphviz <Formula
  url 'http://www.graphviz.org/pub/graphviz/stable/SOURCES/graphviz-2.24.0.tar.gz'
  homepage 'http://graphviz.org/'
  md5 '806a30dbc3f8deb219216f35be0e7a40'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-qartz", "--disable-python"
    system "make install"
  end
end
