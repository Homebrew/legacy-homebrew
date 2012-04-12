require 'formula'

class Openimageio < Formula
  url 'https://github.com/OpenImageIO/oiio/tarball/Release-0.9.0'
  md5 'b9dc646c57c2137d7a9fe8bbb91e0ae7'
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
    # Allow compilation against boost 1.46.0
    # See https://github.com/OpenImageIO/oiio/issues/37
    inreplace "src/libOpenImageIO/imageioplugin.cpp",
      "#include <boost/filesystem.hpp>",
      "#define BOOST_FILESYSTEM_VERSION 2\n#include <boost/filesystem.hpp>"

    # Add include path for libpng explicitly
    system "cmake src/ #{std_cmake_parameters} -DUSE_QT:BOOL=OFF -DEMBEDPLUGINS:BOOL=ON -DCMAKE_CXX_FLAGS=-I/usr/X11/include"
    system "make install"
  end
end
