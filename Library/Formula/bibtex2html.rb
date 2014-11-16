require 'formula'

class Bibtex2html < Formula
  homepage 'http://www.lri.fr/~filliatr/bibtex2html/'
  url 'http://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.98.tar.gz'
  sha1 'daaa082885a30dae38263614565298d4862b8331'

  bottle do
    cellar :any
    sha1 "e82686abe5a9c548d88345d7f42ec21aeb5dd8f6" => :yosemite
    sha1 "6ed6b299de0ef530d868c2b1c73ec7c428fc35d0" => :mavericks
    sha1 "32377bea1f584fedf5d2abb604a1d46e5e92ac5c" => :mountain_lion
  end

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
