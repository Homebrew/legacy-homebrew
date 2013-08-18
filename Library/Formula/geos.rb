require 'formula'

class Geos < Formula
  homepage 'http://trac.osgeo.org/geos'
  url 'http://download.osgeo.org/geos/geos-3.4.1.tar.bz2'
  sha1 '0fee633694049192726149f83c47fef4d73c7468'

  option :universal

  depends_on 'cmake' => :build

  def install
    if build.universal?
      ENV.universal_binary
      ENV['CMAKE_OSX_ARCHITECTURES'] = Hardware::CPU.universal_archs.as_cmake_arch_flags
    end
    system "cmake", ".", *std_cmake_args
    system "make install"
  end
end
