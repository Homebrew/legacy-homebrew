require 'formula'

class Openimageio <Formula
  url 'http://svn.openimageio.org/oiio/branches/RB-0.8/', :using => :svn
  version "0.8"
  homepage 'http://openimageio.org'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build
  depends_on 'ilmbase'
  depends_on 'openexr'
  depends_on 'boost'

  # build plugins
  depends_on 'libpng'  => :optional
  depends_on 'libtiff' => :optional
  depends_on 'jpeg'    => :optional
  depends_on 'jasper'  => :optional

  # Qt linking, to build iv, is not currently working.
  # Would need qt and glew as deps for this.

  depends_on 'tbb' => :optional

  def install
    system "cmake src/ #{std_cmake_parameters} -DUSE_QT:BOOL=OFF -DEMBEDPLUGINS:BOOL=ON -DUPDATE_TYPE:STRING=svn"
    system "make install"
  end
end
