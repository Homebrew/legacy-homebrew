require 'brewkit'

class Gccxml <Formula
  # NOTE you don't need to specify the version, usually it is determined
  # automatically by examination of the URL, however in this case our auto
  # determination magic is inadequete
  version 'HEAD'
  url "cvs://:pserver:anoncvs@www.gccxml.org:/cvsroot/GCC_XML:gccxml"
  homepage 'http://www.gccxml.org/HTML/Index.html'

  depends_on 'cmake'

  def install
    FileUtils.mkdir 'gccxml-build'

    Dir.chdir 'gccxml-build' do
      system "cmake .. #{std_cmake_parameters}"
      system "make"
      system "make install"
    end
  end
end
