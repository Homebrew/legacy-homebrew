require 'formula'

class Clamav < Formula
  url 'http://downloads.sourceforge.net/clamav/clamav-0.97.3.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 '5cf25ed7778fa0cb6b140ad8f009befb'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
