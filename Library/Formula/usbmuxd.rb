require 'formula'

class Usbmuxd <Formula
  url 'http://marcansoft.com/uploads/usbmuxd/usbmuxd-1.0.5.tar.bz2'
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  md5 '484970632a739206afe86802c6169300'

  depends_on 'libusb'
  depends_on 'cmake' => :build

  def install
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    system "cmake . #{std_cmake_parameters} -DLIB_SUFFIX=''"
    system "make install"
  end
end
