require 'formula'

class Vigra < Formula
  homepage 'http://hci.iwr.uni-heidelberg.de/vigra/'
  url 'http://hci.iwr.uni-heidelberg.de/vigra/vigra-1.9.0-src.tar.gz'
  sha1 '6e4981f4ce75932ec62df6523f577c327f885ba0'

  depends_on 'cmake' => :build
  depends_on 'jpeg'
  depends_on :libpng
  depends_on 'libtiff'
  depends_on 'hdf5'
  depends_on 'fftw' => :recommended
  depends_on 'openexr' => :optional


  def install
    cmake_args = std_cmake_args
    cmake_args << '-DWITH_OPENEXR=1' if build.with? 'openexr'
    mkdir 'build' do
      system "cmake", "..", *cmake_args
      system "make install"
    end
  end
end
