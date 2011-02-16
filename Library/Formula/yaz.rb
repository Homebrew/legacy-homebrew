require 'formula'

# NOTE this formula conflicts with icu4c on Snow Leopard at the moment
# if this is a problem for you then please fix it! Thanks.

class Yaz <Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-4.1.3.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 '3e41a35b392e494d0b6d78a243420a84'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
