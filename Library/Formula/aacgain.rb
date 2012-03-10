require 'formula'

class Aacgain < Formula
  url 'http://altosdesign.com/aacgain/alvarez/aacgain-1.8.tar.bz2'
  homepage 'http://altosdesign.com/aacgain/'
  md5 '61ce9e648fa1773adb3d4b3c84c6e4ca'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
