require 'formula'

class Simgrid < Formula
  homepage 'http://simgrid.gforge.inria.fr'
  url 'https://gforge.inria.fr/frs/download.php/29207/simgrid-3.6.2.tar.gz'
  md5 '35b10c0fb6d47bdbbf19417ab0ab2e6c'

  depends_on 'cmake' => :build
  depends_on 'pcre'
  depends_on 'graphviz'

  fails_with :clang do
    build 318
  end

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make install"
  end
end
