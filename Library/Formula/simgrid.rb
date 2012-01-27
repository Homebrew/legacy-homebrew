require 'formula'

class Simgrid < Formula
  homepage 'http://simgrid.gforge.inria.fr'
  url 'https://gforge.inria.fr/frs/download.php/29207/simgrid-3.6.2.tar.gz'
  md5 '35b10c0fb6d47bdbbf19417ab0ab2e6c'

  depends_on 'cmake' => :build
  depends_on 'pcre'
  depends_on 'graphviz'

  def install
    # FIXME This should be replaced with fails_with_clang once available
    if ENV.compiler == :clang
      opoo "Formula will not build with Clang, using LLVM."
      ENV.llvm
    end

    system "cmake -Denable_debug=on -Denable_compile_optimizations=off #{std_cmake_parameters} ."
    system "make install"
  end
end
