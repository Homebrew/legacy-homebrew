require 'formula'

class Osm2pgsql < Formula
  head 'http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/', :using => :svn
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'

  def install
    system "./autogen.sh"
    system "./configure"
    system "make"
    bin.install "osm2pgsql"
  end
end
