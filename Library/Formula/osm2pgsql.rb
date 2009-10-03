require 'brewkit'
require 'date'

class Osm2pgsql <Formula
  head 'http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/'
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'

  def install
    system "make"
    bin.install "osm2pgsql"
  end
  
  def download_strategy
    SubversionDownloadStrategy
  end
  
end
