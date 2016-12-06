require 'formula'

class Ogr2osm < Formula
  url 'http://svn.openstreetmap.org/applications/utils/import/ogr2osm/ogr2osm.py'
  homepage 'http://wiki.openstreetmap.org/wiki/Ogr2osm'
  md5 'ca22c1738a0ed5ec1680e59cb6bc872d'
  version '26782'

  def install
    bin.install Dir['*']
  end
end
