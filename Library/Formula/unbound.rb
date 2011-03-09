require 'formula'

class Unbound <Formula
  url 'http://www.unbound.net/downloads/unbound-1.4.7.tar.gz'
  homepage 'http://www.unbound.net'
  md5 '97ee3c4a9877ff725fad23e31ecadfe0'

  depends_on 'ldns'

  def install
    system "./configure", "--disable-gost", "--disable-sha2", "--with-ssl-optional",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
