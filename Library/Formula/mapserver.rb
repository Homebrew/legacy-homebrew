require 'formula'

class Mapserver < Formula
  url 'http://download.osgeo.org/mapserver/mapserver-6.0.1.tar.gz'
  homepage 'http://mapserver.org/'
  md5 'b96287449dcbca9a2fcea3a64905915a'

  depends_on 'gd'
  depends_on 'proj'
  depends_on 'gdal'

  def install
    system "./configure", "--prefix=#{prefix}", "--with-png=/usr/X11",
           "--with-proj", "--with-gdal"
    system "make"
    bin.install "mapserv"
  end
end
