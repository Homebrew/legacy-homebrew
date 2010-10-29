require 'formula'

class Squid <Formula
  url 'http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.9.tar.bz2'
  homepage 'http://www.squid-cache.org/'
  md5 '13e78641aa8ee1056299c68a80b656d6'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
  end
end
