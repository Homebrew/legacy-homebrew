require "formula"

class Osm2pgsql < Formula
  homepage "http://wiki.openstreetmap.org/wiki/Osm2pgsql"
  url "https://github.com/openstreetmap/osm2pgsql/archive/0.86.0.tar.gz"
  sha1 "243c0db886634b90563217afdc897ad49ab9a238"

  bottle do
    cellar :any
    sha1 "1885597bd9c3edc2cc0ff3a77eeed32e696797a7" => :yosemite
    sha1 "c4f84d422ea950111cc2cd1d0e70a3772ab7981e" => :mavericks
    sha1 "08b6aa91ee4a5dc51fb5ceede2974b07aa90f5a4" => :mountain_lion
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
