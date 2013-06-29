require 'formula'

class Mon < Formula
  homepage 'https://github.com/visionmedia/mon'
  url 'https://github.com/visionmedia/mon/archive/1.2.2.tar.gz'
  sha1 '01af043f44fe8654ce2c82d17ae1664a572064f2'

  def install
    system "make"
    bin.install 'mon'
  end
end
