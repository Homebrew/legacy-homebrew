require 'formula'

class Usbmuxd < Formula
  url 'http://marcansoft.com/uploads/usbmuxd/usbmuxd-1.0.6.tar.bz2'
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  md5 'c8909cfd9253d8d1a5e26f2ff7e5908b'

  depends_on 'libusb'
  depends_on 'cmake' => :build

  def install
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    system "cmake . #{std_cmake_parameters} -DLIB_SUFFIX=''"
    system "make install"
  end
end
