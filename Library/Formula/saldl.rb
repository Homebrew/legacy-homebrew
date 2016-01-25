class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v34.tar.gz"
  sha256 "12053f306306023e5bbdc6bb8594cc83f8793da0ce99dab1981179cdeccea4da"
  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "cf4d932112e68f3fe41439755811d422a4486948f32adf4262df05f47833a47f" => :el_capitan
    sha256 "14da0e3518ed6ea8ffccff42938830f8bea0c7d5f70efd752727177bdae72b19" => :yosemite
    sha256 "6edae3881de9722cb385e2a5160314153b0a0f3d1ac9569fb17fb9ec78d0e810" => :mavericks
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
