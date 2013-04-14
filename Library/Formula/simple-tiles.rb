require 'formula'

class SimpleTiles < Formula
  homepage 'http://propublica.github.io/simple-tiles/'
  url 'https://github.com/propublica/simple-tiles/archive/v0.3.1.tar.gz'
  sha1 '9f5ff17cca9d9cacb36dcf971b57dd3b42b352e2'

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
