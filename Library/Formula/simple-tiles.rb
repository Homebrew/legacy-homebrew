require 'formula'

class SimpleTiles < Formula
  homepage 'http://propublica.github.io/simple-tiles/'
  url 'https://github.com/propublica/simple-tiles/archive/v0.4.1.tar.gz'
  sha1 'fae2f115bf99e725f8fe38dc011718ec1364ed6f'

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
