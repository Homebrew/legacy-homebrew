class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "http://download.osgeo.org/shapelib/shapelib-1.3.0.tar.gz"
  sha256 "23d474016158ab5077db2f599527631706ba5c0dc7c4178a6a1d685bb014f68f"

  bottle do
    cellar :any
    revision 1
    sha256 "ff785bd9efdab4345d8e1409934e173b2b18a35c87f522c30eef097b20c662e1" => :yosemite
    sha256 "30c19104eeb1a1d3f70ea80ed73a352e03e976610a63c5775d77a15eb7da355c" => :mavericks
    sha256 "f8d87f694df8fec823efe62702e317737c53fd5c1407f1007b7d5fae9f37974f" => :mountain_lion
  end

  def install
    dylib = lib+"libshp.#{version}.dylib"

    system "make", "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "PREFIX=#{prefix}"

    lib.mkpath
    system ENV.cc, *%W[-dynamiclib -Wl,-all_load
                       -Wl,-install_name,#{dylib}
                       -Wl,-headerpad_max_install_names
                       -Wl,-compatibility_version,#{version}
                       -o #{dylib}
                       shpopen.o shptree.o dbfopen.o safileio.o]

    include.install "shapefil.h"
    bin.install %w[shpcreate shpadd shpdump shprewind dbfcreate dbfadd dbfdump shptreedump]

    lib.install_symlink dylib.basename => "libshp.#{version.to_s.split(".").first}.dylib"
    lib.install_symlink dylib.basename => "libshp.dylib"
  end
end
