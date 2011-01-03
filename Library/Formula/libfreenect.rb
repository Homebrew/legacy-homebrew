require 'formula'

class Libfreenect <Formula
  url 'https://github.com/gijzelaerr/libfreenect/tarball/master'
  version 'master'
  homepage 'http://openkinect.org'
  md5 'dd0c93cd8d7672ce383e1670b787fcae'
  
  depends_on 'libusb-freenect'
  depends_on 'cmake'
  depends_on 'opencv'

  def install
    mkdir "build"
    cd "build"
    system "cmake .. #{std_cmake_parameters} -DBUILD_CV=ON"
    system "make install"
  end
end
