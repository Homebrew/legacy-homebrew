require 'formula'

class Clamav < Formula
  url 'http://downloads.sourceforge.net/clamav/clamav-0.97.2.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 'cb2d78b4790fdfca3b2390d7ce82f0b7'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
