require 'formula'

class XercesC <Formula
  url 'http://apache.copahost.com/xerces/c/3/sources/xerces-c-3.1.0.tar.gz'
  homepage 'http://xerces.apache.org/xerces-c/'
  md5 '4dc9460e011ed4857dcd290f22dd6f1b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
