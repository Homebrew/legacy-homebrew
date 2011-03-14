require 'formula'

class Openimageio < Formula
  url 'https://github.com/OpenImageIO/oiio/tarball/Release-0.9.0'
  md5 'b9dc646c57c2137d7a9fe8bbb91e0ae7'
  version "0.9.0"
  homepage 'http://openimageio.org'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'ilmbase'
  depends_on 'openexr'
  depends_on 'boost'

  # build plugins
  depends_on 'libtiff' => :optional
  depends_on 'jpeg'    => :optional
  depends_on 'jasper'  => :optional

  # Qt linking, to build iv, is not currently working.
  # Would need qt and glew as deps for this.

  depends_on 'tbb' => :optional

  def install
    system "cmake src/ #{std_cmake_parameters} -DUSE_QT:BOOL=OFF -DEMBEDPLUGINS:BOOL=ON"
    system "make install"
  end
end
