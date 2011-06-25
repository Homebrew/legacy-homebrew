require 'formula'

class Ncdu < Formula
  url 'http://dev.yorhel.nl/download/ncdu-1.6.tar.gz'
  homepage 'http://dev.yorhel.nl/ncdu'
  md5 '95d29cf64af2d8cf4b5005e6e3d60384'

  def install
    # ncdu segfaults when built for 64-bit
    ENV.m32

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
