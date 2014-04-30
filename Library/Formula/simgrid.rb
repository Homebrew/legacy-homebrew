require "formula"

class Simgrid < Formula
  homepage "http://simgrid.gforge.inria.fr/"
  url "http://gforge.inria.fr/frs/download.php/33124/SimGrid-3.10.tar.gz"
  sha1 "2faad1892ad26d27121a1338e7fccd871056a11a"

  depends_on 'cmake' => :build
  depends_on 'pcre'
  depends_on 'graphviz'

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make install"
  end
end
