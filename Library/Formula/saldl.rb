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
  depends_on "libevent"

  # curl >= 7.42 is required
  depends_on "curl" if MacOS.version <= :mavericks

  def install
    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = ["--prefix=#{prefix}"]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" unless build.head?

    # pkg-config is not supported with system libcurl
    args << "--libcurl-libs=-lcurl" if MacOS.version > :mavericks
    args << "--libcurl-cflags=" if MacOS.version > :mavericks

    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "#{bin}/saldl", "http://brew.sh/index.html"
    assert File.exist? "index.html"
  end
end
