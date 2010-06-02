require 'formula'

class Usbmuxd <Formula
  url 'http://marcansoft.com/uploads/usbmuxd/usbmuxd-1.0.4.tar.bz2'
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  md5 '450c72273dd1dcc1d0fcfc7138122d54'

  depends_on 'libusb'
  depends_on 'cmake'

  aka 'usb-multiplex-daemon'

  def install
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    system "cmake . #{std_cmake_parameters} -DLIB_SUFFIX=''"
    system "make install"
  end
end
