require 'formula'

class Pigz < Formula
  homepage 'http://www.zlib.net/pigz/'
  url 'http://www.zlib.net/pigz/pigz-2.3.tar.gz'
  sha1 'c8d4e622863c5ffff9321453acc9a37e9da87af7'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    ln_s 'pigz.1', man1+'unpigz.1'
  end
end
