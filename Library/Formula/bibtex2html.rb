require 'formula'

class Bibtex2html < Formula
  url 'http://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.94.tar.gz'
  homepage 'http://www.lri.fr/~filliatr/bibtex2html/'
  md5 '16e6656156e10c07747163a0914058b8'

  depends_on 'objective-caml'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
