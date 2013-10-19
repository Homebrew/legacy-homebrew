require 'formula'

class Pgrouting < Formula
  homepage 'http://www.pgrouting.org'
  url "https://github.com/pgRouting/pgrouting/archive/v2.0.0.tar.gz"
  sha1 "cd2f60dc49df7bc8c789c8e73ecb9759194fab96"

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'cgal'
  depends_on 'postgis'
  depends_on 'postgresql'

  def install
    mkdir 'build' do
      system "cmake", "-DWITH_DD=ON", "..", *std_cmake_args
      system "make", "install"
    end
  end
end
