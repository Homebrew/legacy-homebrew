class Saldl < Formula
  desc "CLI downloader optimized for speed and early preview."
  homepage "https://saldl.github.io"
  url "https://github.com/saldl/saldl/archive/v31.tar.gz"
  # version "31"
  sha256 "146a980ae2109a391c7a8ab6a1c525458db9bf18f3f0477731c9b876630078b4"

  head do
    # git describe does not work with shallow clones
    url "https://github.com/saldl/saldl.git", :shallow => false
  end

  depends_on "pkg-config" => :build
  depends_on "asciidoc" => :build
  depends_on "curl"
  depends_on "libevent"

  def install
    # a2x/asciidoc needs this to build the man page successfully
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    args = [
      "--libcurl-cflags=-I#{HOMEBREW_PREFIX}/opt/curl/include",
      "--libcurl-libs=-L#{HOMEBREW_PREFIX}/opt/curl/lib -lcurl",
      "--prefix=#{prefix}",
    ]

    # head uses git describe to acquire a version
    args << "--saldl-version=v#{version}" unless build.head?

    system "./waf", "configure", *args
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "saldl", "--version"
  end
end
