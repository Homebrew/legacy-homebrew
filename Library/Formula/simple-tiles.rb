require 'formula'

class SimpleTiles < Formula
  homepage 'http://propublica.github.com/simple-tiles/'
  url 'https://github.com/propublica/simple-tiles/archive/0.3.0.tar.gz'
  sha1 'c0c677b3b212457abc6a39ced4ee3e767be8e885'

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
