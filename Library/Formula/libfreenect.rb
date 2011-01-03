require 'formula'

class Libfreenect <Formula
  url 'https://github.com/OpenKinect/libfreenect/tarball/master'
  version 'master'
  homepage 'http://openkinect.org'
  md5 ''
  
  depends_on 'libusb-freenect'
  depends_on 'cmake'

  def install
    mkdir "build"
    cd "build"
    system "cmake .. #{std_cmake_parameters}"
    system "make install"
  end
end
