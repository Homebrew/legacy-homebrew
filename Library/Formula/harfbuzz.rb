require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.37.tar.bz2"
  sha256 "255f3b3842dead16863d1d0c216643d97b80bfa087aaa8fc5926da24ac120207"

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
    system "make install"
  end
end
