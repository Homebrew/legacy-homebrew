require 'formula'

class Shapelib < Formula
  homepage 'http://shapelib.maptools.org/'
  url 'http://download.osgeo.org/shapelib/shapelib-1.3.0.tar.gz'
  sha1 '599fde6f69424fa55da281506b297f3976585b85'

  def install
    dylib = lib+"libshp.#{version}.dylib"

    inreplace 'Makefile' do |s|
      s.change_make_var! 'CFLAGS', ENV.cflags
      s.change_make_var! 'PREFIX', prefix
      s.gsub!            '#CC = g++', "CC = #{ENV.cc}"
    end
    system 'make'

    lib.mkpath
    system ENV.cc, *%W(-dynamiclib -all_load
                       -install_name #{dylib}
                       -headerpad_max_install_names
                       -compatibility_version #{version}
                       -o #{dylib}
                       shpopen.o shptree.o dbfopen.o safileio.o)

    include.install 'shapefil.h'
    bin.install %w(
      shpcreate shpadd shpdump shprewind dbfcreate dbfadd dbfdump shptreedump
    )

    cd lib do
      ln_s "libshp.#{version}.dylib", "libshp.#{version.to_s.split('.').first}.dylib"
      ln_s "libshp.#{version}.dylib", "libshp.dylib"
    end
  end
end
