require 'formula'

class Clamav < Formula
  url 'http://downloads.sourceforge.net/clamav/clamav-0.97.tar.gz'
  homepage 'http://www.clamav.net/'
  md5 '605ed132b2f8e89df11064adea2b183b'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
