require 'formula'

class Armadillo < Formula
  homepage 'http://arma.sourceforge.net/'
  url 'http://sourceforge.net/projects/arma/files/armadillo-3.2.0.tar.gz'
  sha1 '19f9207c762f7aa1cb8ddfac2223590b566e8f2c'

  depends_on 'cmake' => :build
  depends_on 'boost'

  def install
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
