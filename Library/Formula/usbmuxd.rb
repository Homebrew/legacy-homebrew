require 'formula'

class Usbmuxd <Formula
  url 'http://marcansoft.com/uploads/usbmuxd/usbmuxd-1.0.0-rc2.tar.bz2'
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  md5 '996d5ec74fafae9d2fca0c0d7a75ba71'

  depends_on 'libusb'
  depends_on 'cmake'

  aka 'usb-multiplex-daemon'

  def install
    system "cmake . #{std_cmake_parameters}"
    system "make install"
  end
end
