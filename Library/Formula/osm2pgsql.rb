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
    args = ["--with-proj=#{Formula.factory('proj').opt_prefix}"]
    if build.with? "protobuf-c"
      args << "--with-protobuf-c=#{Formula.factory('protobuf-c').opt_prefix}"
    end
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    bin.install "osm2pgsql"
    (share+'osm2pgsql').install 'default.style'
  end
end
