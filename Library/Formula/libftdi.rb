require 'formula'

class Libftdi < Formula
  url "http://www.intra2net.com/en/developer/libftdi/download/libftdi-0.19.tar.gz"
  homepage 'http://www.intra2net.com/en/developer/libftdi'
  sha1 '0f08caf8e754ace69cd682489fae3f7f09920fe1'

  depends_on 'cmake' => :build
  depends_on 'boost'
  depends_on 'libusb-compat'
  depends_on 'doxygen' => :optional

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end

  def install
    # fix the libs so they are installed in prefix/lib not prefix/lib64
    inreplace 'CMakeLists.txt', 'SET(LIB_SUFFIX 64)', 'SET(LIB_SUFFIX "")'

    mkdir 'macbuild'
    cd 'macbuild' do
      args = std_cmake_parameters.split
      args << '-DPYTHON_BINDINGS=OFF' unless Formula.factory('python').installed?
      args << '..'
      system "cmake", *args
      if Formula.factory('python').installed? then
        inreplace 'bindings/cmake_install.cmake', '/usr/site-packages', "#{lib}/#{which_python}/site-packages"
      end
      system "make"
      system "make install"
      man3.install Dir['doc/man/man3/*']
      doc.install Dir['doc/html/*']
    end
  end
end
