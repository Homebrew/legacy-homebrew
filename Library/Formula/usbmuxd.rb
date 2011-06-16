require 'formula'

class Usbmuxd < Formula
  url 'http://marcansoft.com/uploads/usbmuxd/usbmuxd-1.0.7.tar.bz2'
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  md5 '6f431541f3177fa06aa6df9ceecb2da0'

  depends_on 'cmake' => :build
  depends_on 'libusb'
  depends_on 'libplist'

  def install
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    system "cmake . #{std_cmake_parameters} -DLIB_SUFFIX=''"
    system "make install"
  end
end
