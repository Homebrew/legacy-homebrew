require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.30.tar.bz2"
  sha256 "fa873f9fe4a5ad4f7beb524475e13a5a8729d7414d2bc64a557c0d5651d58586"

  bottle do
    cellar :any
    sha1 "6e555247637793751a9239c4a89f76a2c4dba592" => :mavericks
    sha1 "930861e39cfc46a129f841d86adae5d055420188" => :mountain_lion
    sha1 "81e2eed81f983e81fbab4d19020ebb275bfba727" => :lion
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
