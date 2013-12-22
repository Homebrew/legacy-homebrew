require 'formula'

class Osm2pgrouting < Formula
  homepage 'http://pgrouting.org/docs/tools/osm2pgrouting.html'
  url 'https://github.com/pgRouting/osm2pgrouting.git', :tag => 'v2.0.0'
  sha1 '8c5f5e80ca819f3afb930432498816745947636f'
  head 'https://github.com/pgRouting/osm2pgrouting.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on :postgresql

  def install
    system "cmake", ".", *std_cmake_args
    system "make"

    bin.install 'osm2pgrouting'
    prefix.install Dir['mapconfig*.xml']
  end

  test do
    require 'open3'
    Open3.popen3("#{bin}/osm2pgrouting") do |_, stdout, _|
      assert_equal false, stdout.readlines.empty?, "Nothing written to stdout"
    end
  end
end
