require 'formula'

class Geos <Formula
  url 'http://download.osgeo.org/geos/geos-3.2.1.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 '01f01943bdf598977cee40905c9abfbf'

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    ENV.O3
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
