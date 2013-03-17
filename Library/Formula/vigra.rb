require 'formula'

class Vigra < Formula
  homepage 'http://hci.iwr.uni-heidelberg.de/vigra/'
  url 'http://hci.iwr.uni-heidelberg.de/vigra/vigra-1.9.0-src.tar.gz'
  sha1 '6e4981f4ce75932ec62df6523f577c327f885ba0'

  depends_on 'cmake' => :build
  depends_on 'fftw' => :optional
  depends_on 'hdf5' => :optional
  depends_on 'libjpg'
  depends_on 'libpng'
  depends_on 'libtiff'
  depends_on 'openexr' => :optional

  def install
    args = std_cmake_args
    system "cmake", '.', *args
    system "make install"
  end
end
