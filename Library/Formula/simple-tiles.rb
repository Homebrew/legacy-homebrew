require 'formula'

class SimpleTiles < Formula
  homepage 'http://propublica.github.io/simple-tiles/'
  url 'https://github.com/propublica/simple-tiles/archive/v0.5.0.tar.gz'
  sha1 'dde1359132f29e56e01596cbab58b1ed85d2de08'

  head 'https://github.com/propublica/simple-tiles.git'

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end
