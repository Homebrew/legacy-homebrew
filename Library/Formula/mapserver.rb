require 'formula'

class Mapserver < Formula
  url 'http://download.osgeo.org/mapserver/mapserver-6.0.0.tar.gz'
  homepage 'http://mapserver.org/'
  md5 '5bcb1a6fb4a743e9f069466fbdf4ab76'

  depends_on 'gd'
  depends_on 'proj'
  depends_on 'gdal'
  depends_on 'libagg'

  def patches
    # http://trac.osgeo.org/mapserver/ticket/3877 (patch from the 6.0 release branch)
    { :p4 => "http://trac.osgeo.org/mapserver/changeset/11714?format=diff&new=11714" }
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--with-png=/usr/X11",
           "--with-proj", "--with-gdal", "--with-agg"
    system "make"
    bin.install "mapserv"
  end
end
