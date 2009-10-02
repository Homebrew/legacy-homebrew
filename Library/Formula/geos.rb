require 'brewkit'

class Geos <Formula
  url 'http://download.osgeo.org/geos/geos-3.1.1.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 '196f4424aa4ef94476e6886d3a964fb6'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
