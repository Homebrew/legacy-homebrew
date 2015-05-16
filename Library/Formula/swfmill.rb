require 'formula'

class Swfmill < Formula
  homepage 'http://swfmill.org'
  url 'http://swfmill.org/releases/swfmill-0.3.3.tar.gz'
  sha1 '7aa2c674e20f5649985b6dde3838393c5efefb6e'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'freetype'
  depends_on 'libpng'

  def install
    # Use inreplace instead of a patch due to newlines
    # Reported usptream:
    # https://github.com/djcsdy/swfmill/issues/32
    inreplace "src/swft/swft_import_ttf.cpp",
      "#include <freetype/tttables.h>",
      "#include FT_TRUETYPE_TABLES_H"

    system "./configure", "--prefix=#{prefix}"
    # Has trouble linking against zlib unless we add it here - @adamv
    system "make", "LIBS=-lz", "install"
  end
end
