require 'formula'

class Liblas < Formula
  desc "C/C++ library for reading and writing the LAS LiDAR format"
  homepage 'http://liblas.org'
  url 'http://download.osgeo.org/liblas/libLAS-1.8.0.tar.bz2'
  sha1 '73a29a97dfb8373d51c5e36bdf12a825c44fa398'

  head 'https://github.com/libLAS/libLAS.git'

  bottle do
    sha1 "7a8b736fe0e8637d641d26acf9328dca93d04c2a" => :yosemite
    sha1 "15436841f3d688acfb17f537ebf1e808a462bdb2" => :mavericks
    sha1 "520f9bd2e768601ab1b6ea6dde72c4714090bba2" => :mountain_lion
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
