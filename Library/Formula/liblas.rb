require 'formula'

class Liblas < Formula
  homepage 'http://liblas.org'
  url 'http://download.osgeo.org/liblas/libLAS-1.7.0.tar.gz'
  md5 '03de7a61132902846c12f3b28c38eb37'

  depends_on 'cmake' => :build
  depends_on 'libgeotiff'
  depends_on 'gdal'
  depends_on 'boost'

  def options
    [['--with-test', 'Verify during install with `make test`.']]
  end

  def install
    mkdir 'macbuild' do
      # CMake finds boost, but variables like this were set in the last
      # version of this formula. Now using the variables listed here:
      #   http://liblas.org/compilation.html
      ENV['Boost_INCLUDE_DIR'] = "#{HOMEBREW_PREFIX}/include"
      ENV['Boost_LIBRARY_DIRS'] = "#{HOMEBREW_PREFIX}/lib"
      system "cmake", "..", *std_cmake_args
      system "make"
      system "make test" if ARGV.include? '--with-test'
      system "make install"
    end
  end
end
