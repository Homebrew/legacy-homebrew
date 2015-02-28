class Pdfgrep < Formula
  homepage "http://pdfgrep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfgrep/1.3.2/pdfgrep-1.3.2.tar.gz"
  sha1 "77e82b80daf7859989f38ec3d09b3f03a73a91e8"

  head "https://git.gitorious.org/pdfgrep/pdfgrep.git"

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/pdfgrep", "--version"
  end
end
