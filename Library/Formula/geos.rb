require 'formula'

class Geos < Formula
  url 'http://download.osgeo.org/geos/geos-3.3.0.tar.bz2'
  homepage 'http://trac.osgeo.org/geos/'
  md5 '3301f3d1d747b95749384b8a356b022a'

  def skip_clean? path
    path.extname == '.la'
  end

  def install
    ENV.O3
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end
