class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.38.tar.bz2"
  sha256 "6736f383b4edfcaaeb6f3292302ca382d617d8c79948bb2dd2e8f86cdccfd514"

  bottle do
    cellar :any
    sha1 "edcff2779c5a7917a434777838dde51c88c987e7" => :yosemite
    sha1 "61ac677612d40e13e00c39090ffa19d74d135246" => :mavericks
    sha1 "a7a35c62e4cdfe95868bc923c0c8871ebc25c694" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "cairo"
  depends_on "icu4c" => :recommended
  depends_on "freetype"

  def install
    args = %W[--disable-dependency-tracking --prefix=#{prefix}]
    args << "--with-icu" if build.with? "icu4c"
    system "./configure", *args
    system "make", "install"
  end
end
