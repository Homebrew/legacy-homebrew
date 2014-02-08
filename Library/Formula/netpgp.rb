require "formula"

class Netpgp < Formula
  homepage "http://www.netpgp.com"
  url "http://www.netpgp.com/src/netpgp.tar.gz"
  sha1 "de61bdaaace4778608ab89be1ef6da9bbf5e18ee"
  version "3.99.14"

  def install
    ENV['CFLAGS'] = '-Wno-deprecated-declarations'
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end
end
