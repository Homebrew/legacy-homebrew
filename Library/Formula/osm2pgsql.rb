require 'formula'

class Osm2pgsql < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'
  url 'https://github.com/openstreetmap/osm2pgsql/archive/v0.82.0.zip'
  sha1 '9c0141faad6b93ccd0aa5fd554c6d1fd1af28532'

  depends_on :postgresql
  depends_on :automake
  depends_on :libtool
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :optional

  def install
    proj = Formula.factory('proj')
    system "./autogen.sh"
    system "./configure", "--with-proj=#{proj.opt_prefix}"
    system "make"
    bin.install "osm2pgsql"
    (share+'osm2pgsql').install 'default.style'
  end
end
