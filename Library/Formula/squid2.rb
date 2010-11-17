require 'formula'

class Squid2 <Formula
  url 'http://www.squid-cache.org/Versions/v2/2.7/squid-2.7.STABLE9.tar.gz'
  homepage 'http://www.squid-cache.org/'
  version '2.7.9'
  md5 '7d3b8b0bdda3ae56e438d4a95a97d3b3'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
