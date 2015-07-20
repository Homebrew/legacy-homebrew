class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-1.3.2.tar.gz"
  sha256 "386b167434443dd299d389a0ef292d708123255cbab0e179e11b65ba51d9b386"

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
  end

  bottle do
    cellar :any
    sha256 "a53218bf50749df4b6f4c8a935e71c4dbca43c873f7194866043241d78f61478" => :yosemite
    sha256 "47140f3965dc224850b58a09d1c9b6aac2092671cc86977d16b643c1ee765c1d" => :mavericks
    sha256 "e1a02806c1024b3f3a1cf745617d2e4118687db1d0130ef369c0f171ce52fc8a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
