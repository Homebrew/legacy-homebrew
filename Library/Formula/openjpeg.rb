require 'formula'

class Openjpeg < Formula
  url 'http://openjpeg.googlecode.com/files/openjpeg_v1_4_sources_r697.tgz'
  version '1.4'
  head 'http://openjpeg.googlecode.com/svn/trunk/'
  homepage 'http://www.openjpeg.org/'
  md5 '7870bb84e810dec63fcf3b712ebb93db'

  depends_on 'lcms' => :optional
  depends_on 'cmake' => :build
  depends_on 'libtiff'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
