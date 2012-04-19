require 'formula'

class Usbmuxd < Formula
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  url 'http://cgit.sukimashita.com/usbmuxd.git/snapshot/usbmuxd-1.0.8.tar.bz2'
  md5 '87fd27773a84e97ac6e2dc28b08d682e'

  depends_on 'cmake' => :build
  depends_on 'libusb'
  depends_on 'libplist'

  def install
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'
    File.open('version.tag', 'w') {|f| f.write('1.0.8')}
    system "cmake #{std_cmake_parameters} -DLIB_SUFFIX='' ."
    system "make install"
  end
end
