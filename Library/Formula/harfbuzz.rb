require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.35.tar.bz2"
  sha256 "0aa1a8aba6f502321cf6fef3c9d2c73dde48389c5ed1d3615a7691944c2a06ed"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha1 "55699cec76a60c3d91ee2645e3f86d9d3ea8b05a" => :yosemite
    sha1 "166ca6c96a6123081f9933ac1f6f3d4c15b09027" => :mavericks
    sha1 "9d03998e59b69e9adf441616eee32b89384ad400" => :mountain_lion
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
