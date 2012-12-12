require 'formula'

class Usbmuxd < Formula
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  url 'http://www.libimobiledevice.org/downloads/usbmuxd-1.0.8.tar.bz2'
  sha1 '56bd90d5ff94c1d9c528f8b49deffea25b7384e8'

  head 'http://cgit.sukimashita.com/usbmuxd.git'

  depends_on 'cmake' => :build
  depends_on 'pkg-config' => :build

  depends_on 'libusb'
  depends_on 'libplist'

  def install
    libusb = Formula.factory 'libusb'
    inreplace 'Modules/VersionTag.cmake', '"sh"', '"bash"'

    # The CMake scripts responsible for locating libusb headers are broken. So,
    # we explicitly point the build script at the proper directory.
    mkdir 'build' do
      system "cmake", "..",
                      "-DLIB_SUFFIX=",
                      "-DUSB_INCLUDE_DIR=#{libusb.include.children.first}",
                      *std_cmake_args
      system 'make install'
    end
  end
end
