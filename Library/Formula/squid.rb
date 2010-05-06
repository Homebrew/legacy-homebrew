require 'formula'

class Squid <Formula
  url 'http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.3.tar.bz2'
  homepage 'http://www.squid-cache.org/'
  md5 '5b9ec56d38106826caf3888ab62bf865'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
  end
end
