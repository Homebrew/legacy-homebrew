require 'formula'

class Taglib < Formula
  homepage 'http://taglib.github.io/'
  url 'https://github.com/taglib/taglib/archive/v1.9.1.tar.gz'
  sha1 '44165eda04d49214a0c4de121a4d99ae18b9670b'

  depends_on 'cmake' => :build

  def install
    ENV.append 'CXXFLAGS', "-DNDEBUG=1"
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make install"
  end
end
