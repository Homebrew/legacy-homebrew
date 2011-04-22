require 'formula'

class LibusbDevel < Formula
  # The tag is the same version used in the macports file.
  url 'http://git.libusb.org/libusb.git', :using => :git, :tag => '7da756e09fd97efad2b35b5cee0e2b2550aac2cb'
  version '1.0.8.20100624'
  homepage 'http://www.libusb.org/'
  md5 '37d34e6eaa69a4b645a19ff4ca63ceef'

  def options
    [["--no-universal", "Build an architecture specific binary."]]
  end

  def patches
    #adds support for microsoft kintect from the OpenKinect Library
    "https://gist.github.com/raw/935924/libusb-osx-kinect.diff"
  end

  def install
    ENV.universal_binary
    ENV.append 'LDFLAGS', '-framework IOKit -framework CoreFoundation'
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
