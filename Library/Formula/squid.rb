require 'formula'

class Squid <Formula
  url 'http://www.squid-cache.org/Versions/v3/3.1/squid-3.1.7.tar.bz2'
  homepage 'http://www.squid-cache.org/'
  md5 '83e7aabc1b5bb5b7c83f6dc2f32ca418'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--localstatedir=#{var}"
    system "make install"
  end
end
