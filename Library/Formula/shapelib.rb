require 'formula'

class Shapelib < Formula
  homepage 'http://shapelib.maptools.org/'
  url 'http://download.osgeo.org/shapelib/shapelib-1.2.10.tar.gz'
  md5 '4d96bd926167193d27bf14d56e2d484e'

  def install
    dylib = lib+"libshp.#{version}.dylib"

    inreplace 'Makefile' do |s|
      s.change_make_var! "CFLAGS", ENV.cflags
    end

    system "make all"
    system "make shptree.o"

    lib.mkpath
    system ENV.cc, *%W(-dynamiclib -all_load
                       -install_name #{dylib}
                       -compatibility_version #{version}
                       -o #{dylib}
                       shpopen.o shptree.o dbfopen.o)

    include.install 'shapefil.h'

    cd lib do
      ln_s "libshp.#{version}.dylib", "libshp.#{version.split('.').first}.dylib"
      ln_s "libshp.#{version}.dylib", "libshp.dylib"
    end
  end
end
