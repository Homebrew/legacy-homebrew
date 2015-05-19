class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "http://pdfgrep.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/pdfgrep/1.3.1/pdfgrep-1.3.1.tar.gz"
  sha1 "8d15760af0803ccea32760d5f68abe4224169639"

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
  end

  bottle do
    cellar :any
    revision 1
    sha256 "8eccc779061c814c3896626af4e8c86a7b7913895507c832a9cb14336bfc9b9e" => :yosemite
    sha256 "00c6ee95a9f1bd34190dbf778ec86c3eb3392aeea112b2937df6ac68572d323d" => :mavericks
    sha256 "c2ce6b73ef12b9a2cb2b561aa7d3e54579f070aff4233af74581f29eef0c7efe" => :mountain_lion
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
