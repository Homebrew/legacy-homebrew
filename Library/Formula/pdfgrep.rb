class Pdfgrep < Formula
  desc "Search PDFs for strings matching a regular expression"
  homepage "https://pdfgrep.org/"
  url "https://pdfgrep.org/download/pdfgrep-1.4.1.tar.gz"
  sha256 "db04a210e6bb7b77cd6c54b17f0f6fed0d123a85f97a541b270736a5d3840f2c"

  bottle do
    cellar :any
    sha256 "aa01210c18cae84398d94524d8578dfb738ff524eea05c9f77323a669667f52b" => :el_capitan
    sha256 "79115ba8d82cea98bef279cf755a452e76f28c687b97fc01ee0e3be7228bd559" => :yosemite
    sha256 "9f2b75a9d7e0910f4801794c108b451988c952f3d0690f15c0486b3c80ff12e7" => :mavericks
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
