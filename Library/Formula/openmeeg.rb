require 'formula'

class Openmeeg < Formula
  homepage 'http://www-sop.inria.fr/athena/software/OpenMEEG/'
  url 'https://github.com/openmeeg/openmeeg/tarball/release-2.1'
  md5 '47b2a5aa4fa5d806da8322859ee3b1d8'

  head 'git://github.com/openmeeg/openmeeg.git', :using => :git

  depends_on 'cmake' => :build
  depends_on 'hdf5'

  def install
    system "cmake #{std_cmake_parameters} -DUSE_PROGRESSBAR=ON ."
    system "make install"
  end
end
