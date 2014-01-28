require 'formula'

class Swfmill < Formula
  homepage 'http://swfmill.org'
  url 'http://swfmill.org/releases/swfmill-0.3.3.tar.gz'
  sha1 '7aa2c674e20f5649985b6dde3838393c5efefb6e'

  depends_on 'pkg-config' => :build
  depends_on :freetype
  depends_on :libpng

  def install
    system "./configure", "--prefix=#{prefix}"
    # Has trouble linking against zlib unless we add it here - @adamv
    system "make", "LIBS=-lz", "install"
  end
end
