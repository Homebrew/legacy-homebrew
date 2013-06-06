require 'formula'

class OsmPbf < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/PBF_Format'
  url 'https://github.com/scrosby/OSM-binary/archive/v1.3.0.tar.gz'
  sha1 'bb9bcd776f2876696b5c5d970d3a68c2222a7ac3'

  depends_on 'protobuf'

  def install
    cd 'src' do
      system "make"
      lib.install 'libosmpbf.a'
    end
    include.install Dir['include/*']
  end
end
