require 'formula'

class Pigz < Formula
  url 'http://www.zlib.net/pigz/pigz-2.1.7.tar.gz'
  homepage 'http://www.zlib.net/pigz/'
  md5 'a09e1097fdc05ac0fff763bdb4d2d5e4'

  def install
    system "make"
    bin.install ["pigz", "unpigz"]
    man1.install ["pigz.1"]
    ln_s 'pigz.1', man1+'unpigz.1'
  end
end
