require 'formula'

class Pgrouting < Formula
  homepage 'http://www.pgrouting.org'
  url "https://github.com/pgRouting/pgrouting/archive/v2.0.0-rc1.tar.gz"
  version "2.0.0-rc1"
  sha1 "481077067c754a92f82dabaeaa2a9140881bda25"

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
