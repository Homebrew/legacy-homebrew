require "formula"

class Harfbuzz < Formula
  homepage "http://www.freedesktop.org/wiki/Software/HarfBuzz"
  url "http://www.freedesktop.org/software/harfbuzz/release/harfbuzz-0.9.33.tar.bz2"
  sha256 "d313c5bf04b8acd01e8f16979d6d2e5fe65184eb28816b70ea0f374be11314c7"

  bottle do
    cellar :any
    sha1 "1fb7882bac92e419b2b4ca8b4dbc314d31d64ebd" => :mavericks
    sha1 "dc61d965ab5cf75a5d4989358e31e3b3693bd7b9" => :mountain_lion
    sha1 "aaf295276a02e9f9977b2bf95aed8fa2a8e3f64a" => :lion
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
