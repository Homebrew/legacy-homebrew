class Shapelib < Formula
  desc "Library for reading and writing ArcView Shapefiles"
  homepage "http://shapelib.maptools.org/"
  url "http://download.osgeo.org/shapelib/shapelib-1.3.0.tar.gz"
  sha256 "23d474016158ab5077db2f599527631706ba5c0dc7c4178a6a1d685bb014f68f"

  bottle do
    cellar :any
    revision 1
    sha1 "94876630b25d3118459e6ed1f993a155617ad2ab" => :yosemite
    sha1 "f084d8d30da0f0859527e9c747809e7ad5ea0d07" => :mavericks
    sha1 "0f7ade9614306874b162d89c14ca74c0048281d2" => :mountain_lion
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
