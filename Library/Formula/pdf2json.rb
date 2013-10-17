require 'formula'

class Pdf2json < Formula
  homepage 'http://code.google.com/p/pdf2json/'
  url 'http://pdf2json.googlecode.com/files/pdf2json-0.65.tar.gz'
  sha1 'f7c08c739d1289f2faeda53fd908058ac2d26fe3'

  def install
    system "./configure", "--prefix=#{prefix}"
    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    bin.install 'src/pdf2json'
  end
end
