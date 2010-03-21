require 'formula'

class Lighttpd <Formula
  url 'http://download.lighttpd.net/lighttpd/releases-1.4.x/lighttpd-1.4.26.tar.bz2'
  md5 'a682c8efce47a2f4263a247ba0813c9b'
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
