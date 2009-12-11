require 'formula'

class Lighttpd <Formula
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.25.tar.bz2'
  md5 '2027c49fb46530e45338c5e2da13c02f'
  homepage 'http://www.lighttpd.net/'

  depends_on 'pkg-config'
  depends_on 'pcre'

  def install
    args = ["--prefix=#{prefix}", "--disable-dependency-tracking", 
            "--with-openssl", "--with-ldap"]
    system "./configure", *args
    system "make install"
  end
end
