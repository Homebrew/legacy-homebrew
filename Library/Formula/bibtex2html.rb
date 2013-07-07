require 'formula'

class Bibtex2html < Formula
  homepage 'http://www.lri.fr/~filliatr/bibtex2html/'
  url 'http://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.97.tar.gz'
  sha1 '970cb972eb88ff4cd01f247c0d8a6b821473f243'

  depends_on 'objective-caml'
  depends_on 'hevea'

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace 'Makefile.in' do |s|
      s.remove_make_var! 'STRLIB'
    end

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
