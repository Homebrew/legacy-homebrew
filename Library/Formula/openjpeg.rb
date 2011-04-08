require 'formula'

class Openjpeg < Formula
  head 'http://openjpeg.googlecode.com/svn/trunk/'
  homepage 'http://www.openjpeg.org/'

  depends_on 'cmake' => :build
  depends_on 'libtiff'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
