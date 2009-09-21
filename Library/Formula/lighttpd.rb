require 'brewkit'

class Lighttpd <Formula
  @url='http://www.lighttpd.net/download/lighttpd-1.4.23.tar.bz2'
  @homepage='http://www.lighttpd.net/'
  @md5='0ab6bb7b17bf0f515ce7dce68e5e215a'

  depends_on :pcre

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking", "--with-openssl", "--with-ldap"
    system "make install"
  end
end
