require 'formula'

class Osm2pgsql < Formula
  head 'http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/', :using => :svn
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "geos"
  depends_on "proj"

  def install
    system "./autogen.sh"
    system "./configure"
    system "make"
    bin.install "osm2pgsql"
    (share+'osm2pgsql').install 'default.style'
  end
end
