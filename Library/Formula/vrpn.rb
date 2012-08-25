require 'formula'

class Vrpn < Formula
  homepage 'http://vrpn.org'
  url 'ftp://ftp.cs.unc.edu/pub/packages/GRIP/vrpn/vrpn_07_30.zip'
  sha1 '474f45d524ba959e93630f19666fd03d8f337d90'

  head 'git://git.cs.unc.edu/vrpn.git'

  option 'clients', 'Build client apps and tests'
  option 'docs', 'Build doxygen-based API documentation'

  depends_on 'cmake' => :build
  depends_on 'libusb' # for HID support
  depends_on 'doxygen' if build.include? 'docs'

  def install
    args = std_cmake_args

    if build.include? 'clients'
      args << "-DVRPN_BUILD_CLIENTS:BOOL=ON"
    else
      args << "-DVRPN_BUILD_CLIENTS:BOOL=OFF"
    end
    args << ".."

    mkdir "build" do
      system "cmake", *args
      system "make doc" if build.include? 'docs'
      system "make install"
    end
  end
end
