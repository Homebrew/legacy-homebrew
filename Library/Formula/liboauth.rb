require 'formula'

class Liboauth < Formula
  homepage 'http://liboauth.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/liboauth/liboauth-1.0.3.tar.gz'
  sha1 '791dbb4166b5d2c843c8ff48ac17284cc0884af2'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make install"
  end
end
