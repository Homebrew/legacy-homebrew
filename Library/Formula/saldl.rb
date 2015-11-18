class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v31.tar.gz"
  sha256 "146a980ae2109a391c7a8ab6a1c525458db9bf18f3f0477731c9b876630078b4"

  head do
    # git describe does not work with shallow clones
    url "https://github.com/saldl/saldl.git", :shallow => false
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  # Install DTDs locally for a faster and more reliable build result
  depends_on "docbook-xsl" => :build

  depends_on "libevent"

  # Add option to use keg_only curl formula instead of the version provided by OSX
  if MacOS.version >= :yosemite
    option "with-local-libcurl", "Use keg_only curl formula which provides more features and faster fixes"
  end

  if MacOS.version < :yosemite || build.with?("local-libcurl")
    # curl >= 7.42 is required
    depends_on "curl"
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
