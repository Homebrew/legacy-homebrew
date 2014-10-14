require 'formula'

class Shapelib < Formula
  homepage 'http://shapelib.maptools.org/'
  url 'http://download.osgeo.org/shapelib/shapelib-1.3.0.tar.gz'
  sha1 '599fde6f69424fa55da281506b297f3976585b85'

  bottle do
    cellar :any
    sha1 "57be889ffefc8a5fa66c3595f15a8d1b5e5daf28" => :mavericks
    sha1 "6845193a026890fafed785d9b85ee5ceb65b0f71" => :mountain_lion
    sha1 "25f0d59ecbf9011c00f798b67a9546e78a301ae0" => :lion
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
