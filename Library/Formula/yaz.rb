require 'brewkit'

# NOTE this formula conflicts with icu4c on Snow Leopard at the moment
# if this is a problem for you then please fix it! Thanks.

class Yaz <Formula
  url 'http://ftp.indexdata.dk/pub/yaz/yaz-3.0.48.tar.gz'
  homepage 'http://www.indexdata.com/yaz'
  md5 '6cf27fd487c6ae7d0cbc6dc9e8ae3ba8'

  # depends_on 'openssl'   # we can suffice with the os x default for now

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
