require 'formula'

class Usbmuxd < Formula
  homepage 'http://marcansoft.com/blog/iphonelinux/usbmuxd/'
  url 'http://www.libimobiledevice.org/downloads/usbmuxd-1.0.8.tar.bz2'
  md5 '4b33cc78e479e0f9a6745f9b9a8b60a8'

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
    args = std_cmake_parameters.split.concat %W[
      -DLIB_SUFFIX=''
      -DUSB_INCLUDE_DIR='#{libusb.include.children.first}'
    ]

    mkdir 'build'
    chdir 'build' do
      system 'cmake', '..', *args
      system 'make install'
    end
  end
end
