require 'formula'

class Pigz < Formula
  homepage 'http://www.zlib.net/pigz/'
  url 'http://www.zlib.net/pigz/pigz-2.2.5.tar.gz'
  sha1 '8c7895c7891a4945050a2f6308b9fe3d6b4c28fc'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    ln_s 'pigz.1', man1+'unpigz.1'
  end
end
