require 'formula'

class Osm2pgsql < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'
  head 'http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/'

  depends_on :postgresql
  depends_on :automake
  depends_on :libtool
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :optional

  def install
    system "./autogen.sh"
    system "./configure"
    system "make"
    bin.install "osm2pgsql"
    (share+'osm2pgsql').install 'default.style'
  end
end
