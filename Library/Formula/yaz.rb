require 'formula'

# NOTE this formula conflicts with icu4c on Snow Leopard at the moment
# if this is a problem for you then please fix it! Thanks.

class Yaz <Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-4.1.4.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 'f8068fc2c3d0f2c1d68ff197bd9f8795'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--with-xml2"
    system "make install"
  end
end
