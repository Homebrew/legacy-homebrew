require 'formula'

class Squid <Formula
  url 'http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.9.tar.bz2'
  homepage 'http://www.squid-cache.org/'
  md5 '896ace723445ac168986ba8854437ce3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
  end
end
