require 'formula'

class Taglib < Formula
  url 'https://github.com/downloads/taglib/taglib/taglib-1.7.2.tar.gz'
  md5 'b0a9e797d3833fb933c7c3176de3d720'
  homepage 'http://taglib.github.com/'

  depends_on 'cmake' => :build

  def install
    ENV.append 'CXXFLAGS', "-DNDEBUG=1"
    system "cmake", "-DWITH_MP4=ON", "-DWITH_ASF=ON", *std_cmake_args
    system "make"
    system "make install"
  end
end
