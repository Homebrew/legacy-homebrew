require 'formula'

class OsmPbf < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/PBF_Format'
  head 'git://github.com/scrosby/OSM-binary.git'

  depends_on 'protobuf'

  def install
    system "cd src && make"
    lib.install ['src/libosmpbf.a']
    include.install Dir['include/*']
  end
end
