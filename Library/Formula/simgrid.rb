require 'formula'

class Simgrid < Formula
  homepage 'http://simgrid.gforge.inria.fr'
  url 'https://gforge.inria.fr/frs/download.php/29207/simgrid-3.6.2.tar.gz'
  sha1 'da43c307a40fda00e31f8f1e04fe892d33cc63ed'

  depends_on 'cmake' => :build
  depends_on 'pcre'
  depends_on 'graphviz'

  fails_with :clang do
    cause "Undefined symbols for architecture x86_64"
  end

  def install
    system "cmake", ".",
                    "-Denable_debug=on",
                    "-Denable_compile_optimizations=off",
                    *std_cmake_args
    system "make install"
  end
end
