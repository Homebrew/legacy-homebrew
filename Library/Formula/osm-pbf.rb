require 'formula'

class OsmPbf < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/PBF_Format'
  url 'https://github.com/scrosby/OSM-binary/tarball/v1.2.1'
  sha1 'c12e6649e8aa00a460f54db7f84e723503367fc2'

  depends_on 'protobuf'

  def install
    cd 'src' do
      system "make"
      lib.install 'libosmpbf.a'
    end
    include.install Dir['include/*']
  end
end
