require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.2.2.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 'c5d264acac22fe7720f85dadc1fc17c6'

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    ENV.O3
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
