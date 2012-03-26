require 'formula'

class Openmeeg < Formula
  homepage 'http://openmeeg.gforge.inria.fr/'
  url 'svn://scm.gforge.inria.fr/svn/openmeeg/branches/release-2.1', :using => :svn

  head 'svn://scm.gforge.inria.fr/svn/openmeeg/trunk', :using => :svn

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    system "cmake #{std_cmake_parameters} ."
    system "make install"
  end
end
