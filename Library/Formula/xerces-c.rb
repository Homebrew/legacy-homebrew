require 'brewkit'

class XercesC <Formula
  @url='http://www.osnt.org/apache/xerces/c/3/sources/xerces-c-3.0.1.tar.gz'
  @homepage='http://xerces.apache.org/xerces-c/'
  @md5='293c03f59bf8e956020d73f5b122094c'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
