require 'formula'

class OsmPbf < Formula
  homepage 'http://wiki.openstreetmap.org/wiki/PBF_Format'
  url 'https://github.com/scrosby/OSM-binary/archive/v1.3.3.tar.gz'
  sha1 '639e3eecc00041e6326b69da6c200fabe7ad2895'

  depends_on 'protobuf'

  def install
    cd 'src' do
      system "make"
      lib.install 'libosmpbf.a'
    end
    include.install Dir['include/*']
  end
end
