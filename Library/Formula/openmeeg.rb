require 'formula'

class Openmeeg < Formula
  homepage 'http://openmeeg.gforge.inria.fr/'
  head 'git://github.com/openmeeg/openmeeg.git', :using => :git
  url 'https://github.com/openmeeg/openmeeg/tarball/release-2.1'

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    system "cmake . #{std_cmake_parameters} -DUSE_PROGRESSBAR=ON"
    system "make install"
  end
end
