class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v33.tar.gz"
  sha256 "61b7eb795e158cb6cf7f97fd1b69958b1a43ccbe2688e70354be65f0805d0bf6"
  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "4d2194d3a116534926d43ccdea43fe149141d819d0b7c886105aac08c85f0612" => :el_capitan
    sha256 "d80529b36cf6e88b590bda4b9a8688c0ff7bcc6c986f5f92f341c6e38f61f8d9" => :yosemite
    sha256 "b31ea335b9192a7af9610df915a6bed9f482f9c3d635a7946b5eaf44991230f1" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "docbook-xsl" => :build
  depends_on "libevent"

  if MacOS.version <= :mavericks
    # curl >= 7.42 is required
    depends_on "curl"
  else
    depends_on "curl" => :optional
  end

  def install
    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--prefix=#{prefix}"]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" unless build.head?

    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "#{bin}/saldl", "http://brew.sh/index.html"
    assert File.exist? "index.html"
  end
end
