require 'formula'

class Simgrid < Formula
  url 'https://gforge.inria.fr/frs/download.php/29207/simgrid-3.6.2.tar.gz'
  homepage 'http://simgrid.gforge.inria.fr'
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

    system "cmake . -Denable_debug=on -Denable_compile_optimizations=off #{std_cmake_parameters}"
    system "make install"
  end

  def test
    # In the 3.6.2 following tests seems to be failing on OSX Lion
    # 
    #  21 - tesh-gras-dd-r-little32-4 (SEGFAULT)
    # 105 - msg-chord-raw-parallel (Failed)
    # 124 - gras-pmm-sg-64-raw (Failed)
    # 134 - simdag-test-simdag (SEGFAULT)
    # 139 - tracing-ms (Failed)
    # 156 - testall (SEGFAULT)
    #
    # According to simgrid developers this is a known issues that should
    # not compromise the functinality of the library itself.
    # Once they are resolved, I will update this formula.
    # More details:
    # http://lists.gforge.inria.fr/pipermail/simgrid-user/2012-March/002870.html
    #
    #system "make check"

    system "false"
  end
end
