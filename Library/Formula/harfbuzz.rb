require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.35.tar.bz2"
  sha256 "0aa1a8aba6f502321cf6fef3c9d2c73dde48389c5ed1d3615a7691944c2a06ed"
  revision 1

  bottle do
    cellar :any
    sha1 "d2baeac1dd409726dd7a9058f60ec949bc785d37" => :mavericks
    sha1 "935cf831401eaef960298b981f08d91b8b4d185b" => :mountain_lion
    sha1 "9f06e7f6f44943ea83c3a4e1c5976049c1ea9e0f" => :lion
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
