class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v34.tar.gz"
  sha256 "12053f306306023e5bbdc6bb8594cc83f8793da0ce99dab1981179cdeccea4da"
  head "https://github.com/saldl/saldl.git", :shallow => false

  bottle do
    cellar :any
    sha256 "c8c9a107655b63a0562c026a8e336f1d197088ccc67e1205cd1ada57dace7c14" => :el_capitan
    sha256 "25587806a9e2d1c375501a9bb1523e7f911e49d4b7b8ecc7dc9bed3ecccacc67" => :yosemite
    sha256 "bfd3c6f4f0210db4c300c5d8e0214e5cd6ddb39691893daee4678d6737c5d638" => :mavericks
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
