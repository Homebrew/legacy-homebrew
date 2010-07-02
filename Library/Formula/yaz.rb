require 'formula'

# NOTE this formula conflicts with icu4c on Snow Leopard at the moment
# if this is a problem for you then please fix it! Thanks.

class Yaz <Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-4.0.10.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 'e72edf163640a6a61fd41c12f2c01d2d'

  # depends_on 'openssl'   # we can suffice with the os x default for now

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
