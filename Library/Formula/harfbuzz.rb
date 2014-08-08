require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.34.tar.bz2"
  sha1 "8a8cdbeaf1622459864180fbf453e3ab7343f338"

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
