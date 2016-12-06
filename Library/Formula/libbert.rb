require 'formula'

class Libbert < Formula
  head 'git://github.com/ruediger/libbert.git'
  homepage 'https://github.com/ruediger/libbert'

  depends_on 'cmake'
  depends_on 'boost'

  def install
    system "(mkdir build 2>/dev/null) && cd build && cmake .. #{std_cmake_parameters} -DCMAKE_BUILD_TYPE=Release"
    system "cd build && make"
    system "./tests/test.sh && cd build && make install"
  end
end
