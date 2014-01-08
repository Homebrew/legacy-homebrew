require 'formula'

class Zdelta < Formula
  homepage 'http://cis.poly.edu/zdelta/'
  url 'http://cis.poly.edu/zdelta/downloads/zdelta-2.1.tar.gz'
  sha1 'd25af5d630c4f65f2c57ee84a3e9e0068eac432f'

  def install
    system "make", "test", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    system "make", "install", "prefix=#{prefix}"
    bin.install "zdc", "zdu"
  end
end
