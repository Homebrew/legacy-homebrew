require 'formula'

class Pdf2json < Formula
  url 'http://pdf2json.googlecode.com/files/pdf2json-0.52-source.tar.gz'
  homepage 'http://code.google.com/p/pdf2json/'
  sha1 '2ec59f73cf72227d92ad91ab3e873433a60df81c'

  depends_on 'xpdf'

  def install
    system "./configure", "--prefix=#{prefix}"
    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"
    system "make", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
    system "make install"
  end
end
