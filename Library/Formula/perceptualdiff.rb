require 'formula'

class Perceptualdiff < Formula
  url 'http://downloads.sourceforge.net/project/pdiff/pdiff/perceptualdiff-1.1.1/perceptualdiff-1.1.1-src.tar.gz?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fpdiff%2Ffiles%2Fpdiff%2Fperceptualdiff-1.1.1%2F&ts=1292890840&use_mirror=cdnetworks-us-1'
  homepage 'http://pdiff.sourceforge.net/'
  md5 '8fbd197a4be33fc116e26478c1ff8ce7'

  depends_on 'cmake'
  depends_on 'freeimage'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make ."
    system "make install"
  end
end
