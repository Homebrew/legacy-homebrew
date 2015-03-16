require 'formula'

class Pigz < Formula
  homepage 'http://www.zlib.net/pigz/'
  url 'http://www.zlib.net/pigz/pigz-2.3.3.tar.gz'
  sha1 '11252d38fe2a7b8d7a712dff22bbb7630287d00b'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    ln_s 'pigz.1', man1+'unpigz.1'
  end
end
