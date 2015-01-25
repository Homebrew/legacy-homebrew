class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.38.tar.bz2"
  sha256 "6736f383b4edfcaaeb6f3292302ca382d617d8c79948bb2dd2e8f86cdccfd514"

  bottle do
    cellar :any
    sha1 "6a678869e7401ee144383f9e2001adc666b079f0" => :yosemite
    sha1 "36ad382c9db0bee4bd418303cec80217102c3103" => :mavericks
    sha1 "c2304fab98abcc8a2a1798cc4d02bf6a1144c942" => :mountain_lion
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
