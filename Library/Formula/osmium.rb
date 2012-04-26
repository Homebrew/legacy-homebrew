require 'formula'

class Osmium < Formula
  head 'https://github.com/joto/osmium.git'
  homepage 'http://wiki.openstreetmap.org/wiki/Osmium'
  md5 'dce9eb59d86caf1186fc93567b94feed'

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

  skip_clean :all

  def install
    cd 'osmjs' do
      system "make"
      bin.install 'osmjs'
    end
    system "make doc"

    include.install Dir['include/*']
    doc.install Dir['doc/*']
  end
end
