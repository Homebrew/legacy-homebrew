require 'formula'

class Perceptualdiff < Formula
  url 'http://downloads.sourceforge.net/project/pdiff/pdiff/perceptualdiff-1.1.1/perceptualdiff-1.1.1-src.tar.gz'
  md5 '8fbd197a4be33fc116e26478c1ff8ce7'
  homepage 'http://pdiff.sourceforge.net/'

  depends_on 'cmake'
  depends_on 'freeimage'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
