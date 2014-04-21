require 'formula'

class Osm2pgsql < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'
  url 'https://github.com/openstreetmap/osm2pgsql/archive/0.84.0.tar.gz'
  sha1 '42145c39596580680f120a07a4f30f97a86a3698'

  depends_on :postgresql
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :optional

  def install
    args = ["--with-proj=#{Formula["proj"].opt_prefix}"]
    if build.with? "protobuf-c"
      args << "--with-protobuf-c=#{Formula["protobuf-c"].opt_prefix}"
    end
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    bin.install "osm2pgsql"
    (share+'osm2pgsql').install 'default.style'
  end
end
