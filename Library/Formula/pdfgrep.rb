require "formula"

class Pdfgrep < Formula
  homepage "http://pdfgrep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfgrep/1.3.1/pdfgrep-1.3.1.tar.gz"
  sha1 "8d15760af0803ccea32760d5f68abe4224169639"

  head "https://git.gitorious.org/pdfgrep/pdfgrep.git"

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/pdfgrep", "--version"
  end
end
