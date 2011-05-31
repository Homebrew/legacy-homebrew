require 'formula'

class LibusbFreenect <Formula
  url 'http://git.libusb.org/?p=libusb.git;a=snapshot;h=7da756e09fd97efad2b35b5cee0e2b2550aac2cb;sf=tgz;js=1'
  homepage 'http://www.libusb.org/'
  version "7da756e09fd97efad2b3"
  md5 ''
  def patches
    # patches libusb to work with libfreenect
    "https://github.com/OpenKinect/libfreenect/raw/master/platform/osx/libusb-osx-kinect.diff"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end
