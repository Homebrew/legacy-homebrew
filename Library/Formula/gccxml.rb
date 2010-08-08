require 'formula'

class Gccxml <Formula
  url "cvs://:pserver:anoncvs@www.gccxml.org:/cvsroot/GCC_XML:gccxml"
  version 'HEAD'
  homepage 'http://www.gccxml.org/HTML/Index.html'

  depends_on 'cmake'

  def install
    mkdir 'gccxml-build'
    Dir.chdir 'gccxml-build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make"
      system "make install"
    end
  end
end
