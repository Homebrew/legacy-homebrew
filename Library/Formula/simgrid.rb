require 'formula'

class Simgrid < Formula
  homepage 'http://simgrid.gforge.inria.fr'
  url 'http://gforge.inria.fr/frs/download.php/file/33686/SimGrid-3.11.1.tar.gz'
  sha1 'b00585e2ed11d016eff6252384205e1e990f5895'

  depends_on 'cmake' => :build
  depends_on 'boost' => :optional unless MacOS.version <= :mountain_lion
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
