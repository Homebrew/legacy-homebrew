require 'formula'

class OsmPbf < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/PBF_Format'
  url 'https://github.com/scrosby/OSM-binary/archive/v1.3.1.tar.gz'
  sha1 '4713e693dee3da42178764c8cb9b08188eb47a0d'

  depends_on 'protobuf'

  def install
    cd 'src' do
      system "make"
      lib.install 'libosmpbf.a'
    end
    include.install Dir['include/*']
  end
end
