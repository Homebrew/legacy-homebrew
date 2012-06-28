require 'formula'

class Gccxml < Formula
  homepage 'http://www.gccxml.org/HTML/Index.html'
  head "cvs://:pserver:anoncvs@www.gccxml.org:/cvsroot/GCC_XML:gccxml"

  depends_on 'cmake' => :build

  def install
    mkdir 'gccxml-build' do
      system "cmake", ".", *std_cmake_args
      system "make"
      system "make install"
    end
  end
end
