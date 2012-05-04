require 'formula'

class Usbmuxd < Formula
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  url 'http://www.libimobiledevice.org/downloads/usbmuxd-1.0.8.tar.bz2'
  md5 '4b33cc78e479e0f9a6745f9b9a8b60a8'

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
