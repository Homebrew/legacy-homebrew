require 'formula'

class Geos <Formula
  url 'http://download.osgeo.org/geos/geos-3.2.0.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 'bfad7129680f0107b6ca9a2b92a2c440'

  def install
    ENV.O3
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
