class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-1.4.1.tar.gz"
  sha256 "db04a210e6bb7b77cd6c54b17f0f6fed0d123a85f97a541b270736a5d3840f2c"

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
  end

  bottle do
    cellar :any
    sha256 "b50c6e71def4b4fdae303a083fa7813fa2734805f7779e5a519f588f532e92bd" => :el_capitan
    sha256 "a53218bf50749df4b6f4c8a935e71c4dbca43c873f7194866043241d78f61478" => :yosemite
    sha256 "47140f3965dc224850b58a09d1c9b6aac2092671cc86977d16b643c1ee765c1d" => :mavericks
    sha256 "e1a02806c1024b3f3a1cf745617d2e4118687db1d0130ef369c0f171ce52fc8a" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"
  depends_on "pcre" => :optional

  def install
    system "./autogen.sh" if build.head?

    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--without-libpcre" if build.without? "pcre"
    system "./configure", *args

    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
    system "make", "install"
  end

  test do
    system bin/"pdfgrep", "-i", "homebrew", test_fixtures("test.pdf")
  end
end
