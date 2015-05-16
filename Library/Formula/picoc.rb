require 'formula'

class Picoc < Formula
  homepage 'http://code.google.com/p/picoc/'
  url 'https://picoc.googlecode.com/files/picoc-2.1.tar.bz2'
  sha1 '24fdc3c8302915d663fcaefaf878ab5ad5a2d69b'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags} -DUNIX_HOST"
    bin.install "picoc"
  end
end
