require 'formula'

class Liblas < Formula
  homepage 'http://liblas.org'
  url 'http://download.osgeo.org/liblas/libLAS-1.8.0.tar.bz2'
  sha1 '73a29a97dfb8373d51c5e36bdf12a825c44fa398'

  head 'https://github.com/libLAS/libLAS.git'

  bottle do
    cellar :any
    revision 1
    sha1 "9a0b8ec271d2d3d270cc0915084783197b9fc4d5" => :yosemite
    sha1 "6be05807ebaa6ef9ca82498f4ca5ab2e13e3c450" => :mavericks
    sha1 "864e456c0e74137730b55caa5e89c772f4bcfa60" => :mountain_lion
  end

  depends_on 'cmake' => :build
  depends_on 'libgeotiff'
  depends_on 'gdal'
  depends_on 'boost'
  depends_on 'laszip' => :optional

  option 'with-test', 'Verify during install with `make test`'

  def install
    mkdir 'macbuild' do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   http://liblas.org/compilation.html
      ENV['Boost_INCLUDE_DIR'] = "#{HOMEBREW_PREFIX}/include"
      ENV['Boost_LIBRARY_DIRS'] = "#{HOMEBREW_PREFIX}/lib"
      args = ["-DWITH_GEOTIFF=ON", "-DWITH_GDAL=ON"] + std_cmake_args
      args << "-DWITH_LASZIP=ON" if build.with? 'laszip'
      system "cmake", "..", *args
      system "make"
      system "make test" if build.with? "test"
      system "make install"
    end
  end

  test do
    system bin/"liblas-config", "--version"
  end
end
