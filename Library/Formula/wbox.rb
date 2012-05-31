require 'formula'

class Wbox < Formula
  homepage 'http://hping.org/wbox/'
  url 'http://hping.org/wbox/wbox-5.tar.gz'
  md5 'a95ca2c69982db10704b5ed482c9c722'

  def install
    system "make"
    bin.install "wbox"
  end

  def test
    system "#{bin}/wbox", "www.google.com", "1"
  end
end
