class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v31.tar.gz"
  sha256 "146a980ae2109a391c7a8ab6a1c525458db9bf18f3f0477731c9b876630078b4"
  bottle do
    cellar :any
    sha256 "416d951decbb228df958fdfd89b94dbe3dafede3cea23a165e80a8acb858237d" => :el_capitan
    sha256 "7b697470f9ef296d4528ccec847dc160df78a7dac15cd3927be6d609a71100fb" => :yosemite
    sha256 "a83c726df1115fac1ce66cd22bd545b7f27d1da01b7a3fd6472d793d039e82a4" => :mavericks
  end

  head "https://github.com/saldl/saldl.git", :shallow => false

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
