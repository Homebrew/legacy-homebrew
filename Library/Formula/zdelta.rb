require 'formula'

class Zdelta < Formula
  homepage 'http://cis.poly.edu/zdelta/'
  url 'http://cis.poly.edu/zdelta/downloads/zdelta-2.1.tar.gz'
  md5 'c69583a64f42f69a39e297d0d27d77e5'

  def install
    system "make", "test", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "prefix=#{prefix}"
    bin.install "zdc", "zdu"
  end
end
