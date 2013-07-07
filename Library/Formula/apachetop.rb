require 'formula'

class Apachetop < Formula
  homepage 'http://freecode.com/projects/apachetop'
  url 'http://www.webta.org/apachetop/apachetop-0.12.6.tar.gz'
  sha1 '005c9479800a418ee7febe5027478ca8cbf3c51b'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log"
    system "make install"
  end
end
