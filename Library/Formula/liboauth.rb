require 'formula'

class Liboauth < Formula
  homepage 'http://liboauth.sourceforge.net'
  url 'http://downloads.sourceforge.net/project/liboauth/liboauth-1.0.1.tar.gz'
  sha1 '2631b489c150187adcca264fe813d58b2c22bf8a'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-curl"
    system "make install"
  end
end
