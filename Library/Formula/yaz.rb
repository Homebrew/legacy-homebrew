require 'formula'

# NOTE this formula conflicts with icu4c on Snow Leopard at the moment
# if this is a problem for you then please fix it! Thanks.

class Yaz <Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-4.1.2.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 '54e76ff8ee6f460d68678df298e7da71'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
