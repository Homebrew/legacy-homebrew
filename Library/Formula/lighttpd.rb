require 'formula'

class Lighttpd <Formula
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.28.tar.bz2'
  md5 '586eb535d31ac299652495b058dd87c4'
  homepage 'http://www.lighttpd.net/'

  depends_on 'pkg-config' => :build
  depends_on 'pcre'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-openssl", "--with-ldap"
    system "make install"
  end
end
