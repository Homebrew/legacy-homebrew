require 'formula'

class SimpleTiles < Formula
  homepage 'http://propublica.github.io/simple-tiles/'
  url 'https://github.com/propublica/simple-tiles/archive/v0.4.0.tar.gz'
  sha1 '7ab95f5bd697ac00e8a5406e26007dc717734209'

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
