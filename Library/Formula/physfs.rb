require 'formula'

class Physfs <Formula
  url 'http://icculus.org/physfs/downloads/physfs-2.0.1.tar.gz'
  homepage 'http://icculus.org/physfs/'
  md5 'df00465fcfa80e87f718961c6dd6b928'

  depends_on 'cmake' => :build

  def install
    system "cmake . #{std_cmake_parameters} -DPHYSFS_BUILD_WX_TEST=FALSE"
    system "make install"
  end
end
