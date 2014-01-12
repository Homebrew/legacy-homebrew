require 'formula'

class Freexl < Formula
  homepage 'https://www.gaia-gis.it/fossil/freexl/index'
  url 'http://www.gaia-gis.it/gaia-sins/freexl-1.0.0g.tar.gz'
  sha1 '2a5b1d3ebbaf217c7bda15b5b3f1e0222c6c1502'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end
