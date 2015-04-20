class Pdfgrep < Formula
  homepage "http://pdfgrep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfgrep/1.3.1/pdfgrep-1.3.1.tar.gz"
  sha1 "8d15760af0803ccea32760d5f68abe4224169639"

  head "https://git.gitorious.org/pdfgrep/pdfgrep.git"

  bottle do
    cellar :any
    sha1 "c97fb86fb4f8bb91ce5ced1a0b5a26ae25157ea9" => :yosemite
    sha1 "c562a14dd41e33ec105f4f0735c0b7f0fc6e96b6" => :mavericks
    sha1 "cfc5c5ddc203b615ce93ecbb70e1e103b29d8591" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
