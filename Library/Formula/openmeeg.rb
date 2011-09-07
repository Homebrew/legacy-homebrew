require 'formula'

class Openmeeg < Formula
  head 'svn://scm.gforge.inria.fr/svn/openmeeg/trunk', :using => :svn
  homepage 'http://openmeeg.gforge.inria.fr/'

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    system "cmake . -DCMAKE_INSTALL_PREFIX=#{prefix} -DCMAKE_BUILD_TYPE=Release"
    system "make install"
  end
end
