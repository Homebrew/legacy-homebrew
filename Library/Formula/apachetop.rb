require 'formula'

class Apachetop < Formula
  url 'http://www.webta.org/apachetop/apachetop-0.12.6.tar.gz'
  homepage 'http://www.webta.org/projects/apachetop/'
  md5 '604283ac4bbbddd98fc9b1f11381657e'

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-debug",
                          "--disable-dependency-tracking",
                          "--with-logfile=/var/log/apache2/access_log"
    system "make install"
  end
end
