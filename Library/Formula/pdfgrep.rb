require 'formula'

class Pdfgrep < Formula
  url 'http://sourceforge.net/projects/pdfgrep/files/1.2/pdfgrep-1.2.tar.gz'
  homepage 'http://pdfgrep.sourceforge.net/'
  md5 '80dc5159e9776c99af377550da4c907d'
  head 'https://git.gitorious.org/pdfgrep/pdfgrep.git'

  depends_on 'pkg-config' => :build
  depends_on 'poppler'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/pdfgrep --version"
  end
end
