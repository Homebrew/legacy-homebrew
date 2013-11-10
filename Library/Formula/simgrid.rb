require 'formula'

class Simgrid < Formula
  homepage 'http://simgrid.gforge.inria.fr'
  url 'http://gforge.inria.fr/frs/download.php/32047/SimGrid-3.9.tar.gz'
  sha1 '54e3b718d7b07afdefab6c433e11d1a7bf4cb499'

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
