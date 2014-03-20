require 'formula'

class Osm2pgrouting < Formula
  homepage 'http://pgrouting.org/docs/tools/osm2pgrouting.html'
  url 'https://github.com/pgRouting/osm2pgrouting/archive/v2.0.0.tar.gz'
  sha1 '2d100ac9914919993a7c341e2395b8bafdfe3759'
  head 'https://github.com/pgRouting/osm2pgrouting.git', :branch => 'master'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on :postgresql

  def install
    # Fixes the default hard-coded /usr/share which the program would be installed in.
    # Instead we supply relative paths, and run cmake with flag -DCMAKE_INSTALL_PREFIX=#{prefix} so that
    # we get a proper path inside prefix.
    inreplace "CMakeLists.txt" do |s|
      s.gsub! "/usr/share/osm2pgrouting", "."
      s.gsub! "/usr/share/bin", "bin"
    end

    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end
end
