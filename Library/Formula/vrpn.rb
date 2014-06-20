require 'formula'

class Vrpn < Formula
  homepage 'http://vrpn.org'
  url 'http://www.cs.unc.edu/Research/vrpn/downloads/vrpn_07_31.zip'
  sha1 'a78dd36cd301a7def2d54576cfa63604a8729ace'

  head 'git://git.cs.unc.edu/vrpn.git'

  option 'clients', 'Build client apps and tests'
  option 'docs', 'Build doxygen-based API documentation'

  depends_on 'cmake' => :build
  depends_on 'libusb' # for HID support
  depends_on 'doxygen' if build.include? 'docs'

  def install
    ENV.libstdcxx

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
