require 'formula'

class Usbmuxd < Formula
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  url 'http://marcansoft.com/uploads/usbmuxd/usbmuxd-1.0.7.tar.bz2'
  md5 '6f431541f3177fa06aa6df9ceecb2da0'

  head 'http://cgit.sukimashita.com/usbmuxd.git'

  depends_on 'cmake' => :build
  depends_on 'libusb'
  depends_on 'libplist'

  def install
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    system "cmake #{std_cmake_parameters} -DLIB_SUFFIX='' ."
    system "make install"
  end
end
