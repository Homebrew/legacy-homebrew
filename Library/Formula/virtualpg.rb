require 'formula'

class Virtualpg < Formula
  homepage 'https://www.gaia-gis.it/fossil/virtualpg/index'
  url 'http://www.gaia-gis.it/gaia-sins/virtualpg-1.0.0.tar.gz'
  sha1 '8c7959beb1cff78d3c00255fe73c748d1a5b250b'

  depends_on 'libspatialite'
  depends_on 'postgis'

  def install
    system "./configure", "--enable-shared=yes",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
