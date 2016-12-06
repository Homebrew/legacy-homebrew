require 'formula'

class Zlib < Formula
  url 'http://zlib.net/zlib-1.2.5.tar.gz'
  homepage 'http://www.zlib.net/'
  md5 'c735eab2d659a96e5a594c9e8541ad63'

  depends_on 'cmake'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
