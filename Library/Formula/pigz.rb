require 'formula'

class Pigz < Formula
  homepage 'http://www.zlib.net/pigz/'
  url 'http://www.zlib.net/pigz/pigz-2.2.4.tar.gz'
  md5 '9df2a3c742524446fa4e797c17e8fd85'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install "pigz", "unpigz"
    man1.install "pigz.1"
    ln_s 'pigz.1', man1+'unpigz.1'
  end
end
