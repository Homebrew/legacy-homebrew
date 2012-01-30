require 'formula'

class Pdf2json < Formula
  url 'http://pdf2json.googlecode.com/files/pdf2json-0.52-source.tar.gz'
  homepage 'http://code.google.com/p/pdf2json/'
  md5 '6f2c611bd30218391b0ff35d5a7df049'

  depends_on 'xpdf'

  def install
    system "./configure", "--prefix=#{prefix}"
    # Fix manpage install location. See:
    # http://code.google.com/p/pdf2json/issues/detail?id=2
    inreplace "Makefile", "/man/", "/share/man/"
    system "make"
    system "make install"
  end
end
