require 'formula'

class Perceptualdiff < Formula
  homepage 'http://pdiff.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/pdiff/pdiff/perceptualdiff-1.1.1/perceptualdiff-1.1.1-src.tar.gz'
  sha1 '45be238e657313aed9977f43e5a7fde6e55dddc7'

  depends_on 'cmake' => :build
  depends_on 'freeimage'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
