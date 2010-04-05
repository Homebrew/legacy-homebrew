require 'formula'

class Openimageio <Formula
  head 'http://svn.openimageio.org/oiio/branches/RB-0.8/', :using => :svn
  version "0.8"
  homepage 'http://openimageio.org'

  depends_on 'pkg-config'
  depends_on 'cmake'
  depends_on 'ilmbase'
  depends_on 'openexr'
  depends_on 'boost'

  # build plugins
  depends_on 'libpng' => :optional
  depends_on 'libtiff' => :optional
  depends_on 'jpeg' => :optional
  depends_on 'jasper' => :optional

  # Qt linking not currently working.
  # # build iv
  # depends_on 'qt' => :optional
  # depends_on 'glew' => :optional

  depends_on 'tbb' => :optional

  def install
    system "make USE_QT=0"
    system "make install"
  end
end
