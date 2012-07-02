require 'formula'

class Taglib < Formula
  homepage 'http://taglib.github.com/'
  url 'https://github.com/downloads/taglib/taglib/taglib-1.7.2.tar.gz'
  sha1 'e657384ccf3284db2daba32dccece74534286012'

  depends_on 'cmake' => :build

  def install
    ENV.append 'CXXFLAGS', "-DNDEBUG=1"
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make install"
  end
end
