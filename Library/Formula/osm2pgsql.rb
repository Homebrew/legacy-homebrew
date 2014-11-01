require "formula"

class Osm2pgsql < Formula
  homepage "http://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.86.0.tar.gz"
  sha1 "243c0db886634b90563217afdc897ad49ab9a238"

  bottle do
    cellar :any
    sha1 "dc345c1a9879184ad88a193e9a6ebfcf65f3750a" => :mavericks
    sha1 "b4ecf55fdc125fccb7d994004b46938e8636fbcf" => :mountain_lion
    sha1 "e0dd38b56230cfdad09abda16594fe978352b515" => :lion
  end

  depends_on :postgresql
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "geos"
  depends_on "proj"
  depends_on "protobuf-c" => :optional

  def install
    args = [
      "--with-proj=#{Formula["proj"].opt_prefix}",
      "--with-zlib=/usr",
      "--with-bzip2=/usr"
    ]
    if build.with? "protobuf-c"
      args << "--with-protobuf-c=#{Formula["protobuf-c"].opt_prefix}"
    end
    system "./autogen.sh"
    system "./configure", *args
    system "make"
    bin.install "osm2pgsql"
    (share+"osm2pgsql").install "default.style"
  end
end
