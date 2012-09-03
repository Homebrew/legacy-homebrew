require 'formula'

class Bibtex2html < Formula
  url 'http://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.94.tar.gz'
  homepage 'http://www.lri.fr/~filliatr/bibtex2html/'
  sha1 '710ecf4e20f8dffabb0684222d7de3cf502cb691'

  depends_on 'objective-caml'

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace 'Makefile.in' do |s|
      s.remove_make_var! 'STRLIB'
    end

    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end
