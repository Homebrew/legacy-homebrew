require 'formula'

class Pdf2json < Formula
  homepage 'http://code.google.com/p/pdf2json/'
  url 'https://pdf2json.googlecode.com/files/pdf2json-0.68.tar.gz'
  sha1 '1cb0f4b3b1216c6ce515fd256d92ac196d002a7e'

  def install
    system "./configure", "--prefix=#{prefix}"
    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install 'src/pdf2json'
  end
end
