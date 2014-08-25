require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.35.tar.bz2"
  sha256 "0aa1a8aba6f502321cf6fef3c9d2c73dde48389c5ed1d3615a7691944c2a06ed"

  bottle do
    cellar :any
    sha1 "f03537e2a9eca0407e84fcf88a9601808d65e2d8" => :mavericks
    sha1 "0805fe1b177832da89b341d458661ba5af22abc7" => :mountain_lion
    sha1 "99eb7fdff455eae118cb26d285c016ef980f8c6b" => :lion
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
