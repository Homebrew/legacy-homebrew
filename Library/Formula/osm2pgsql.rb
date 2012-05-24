require 'formula'

class PostgresqlInstalled < Requirement
  def message; <<-EOS.undent
    PostgresQL is required to install.

    You can install this with:
      brew install postgresql

    Or you can use an official installer from:
      http://www.postgresql.org/
    EOS
  end
  def satisfied?
    which 'pg_config'
  end
  def fatal?
    true
  end
end

class Osm2pgsql < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/Osm2pgsql'
  head 'http://svn.openstreetmap.org/applications/utils/export/osm2pgsql/'

  if MacOS.xcode_version >= "4.3"
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on PostgresqlInstalled.new
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
