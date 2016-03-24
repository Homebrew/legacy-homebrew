class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-1.4.1.tar.gz"
  sha256 "db04a210e6bb7b77cd6c54b17f0f6fed0d123a85f97a541b270736a5d3840f2c"

  bottle do
    cellar :any
    revision 1
    sha256 "821ab1b17b4f314f184f6277255fefd2f88457850a258bc8d041c5301780b416" => :el_capitan
    sha256 "0eba080d293bfad89420f25b37a8810d937848c44d705afbb1764ccdf9c8a321" => :yosemite
    sha256 "ffa47430a9f736b1f6d52fad14d9cc4a677f842498101dc358d43de48ec9017c" => :mavericks
  end

  head do
    url "https://gitlab.com/pdfgrep/pdfgrep.git"
    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "asciidoc" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "poppler"
  depends_on "pcre" => :optional

  needs :cxx11

  def install
    ENV.cxx11
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
