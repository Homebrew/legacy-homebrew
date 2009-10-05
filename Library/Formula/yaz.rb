require 'brewkit'

# NOTE this formula conflicts with icu4c on Snow Leopard at the moment
# if this is a problem for you then please fix it! Thanks.

class Yaz <Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-3.0.49.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 '7402c6444386dc7db6be8bb9617e1e4d'

  # depends_on 'openssl'   # we can suffice with the os x default for now

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
