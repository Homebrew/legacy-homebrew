require 'formula'

class Osmium < Formula
  homepage 'https://github.com/joto/osmium'
  url 'https://github.com/MaZderMind/osmium/tarball/2012-06-07'
  head 'https://github.com/joto/osmium.git'
  sha1 'a546caa47f9e9993481564657e6376a4553eb5e1'
  version '2012-06-07'

  depends_on 'boost'
  depends_on 'lzlib'
  depends_on 'shapelib'
  depends_on 'expat'
  depends_on 'geos'
  depends_on 'protobuf'
  depends_on 'v8'
  depends_on 'icu4c'
  depends_on 'google-sparsehash'
  depends_on 'osm-pbf'
  depends_on 'libgd'
  depends_on 'doxygen'
  depends_on 'libspatialite'
  depends_on 'gdal'

  def install
    cd 'osmjs' do
      icu = Formula.factory('icu4c')
      
      ENV['CPLUS_INCLUDE_PATH'] = icu.include
      ENV['LIBRARY_PATH'] = icu.lib
      
      system 'make'
      bin.install 'osmjs'
    end

    cd 'examples' do
      system 'make'

      # install all files beginning with osmium_ but without a dot (excluding cpp and dSYM)
      bin.install Dir['osmium_*'].find_all{|item| not item.include? '.'}
      bin.install 'nodedensity'
    end

    system 'make doc'

    include.install Dir['include/*']
    doc.install Dir['doc/*']
  end

  def caveats; <<-EOS.undent
    parts of osmium depend on gdal with spatialite-support. if you find yourself
    needing spatialite, reinstall gdal like this before compiling your program:
    > brew rm gdal
    > brew install gdal --complete
    EOS
  end
end
