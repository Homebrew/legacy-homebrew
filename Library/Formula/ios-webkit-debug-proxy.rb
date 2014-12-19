require 'formula'

class IosWebkitDebugProxy < Formula
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.4.tar.gz'
  sha1 'e6d882182fe2fd8f5827a9289545cc7e9ebb25e7'
  revision 1

  bottle do
    cellar :any
    sha1 "2cebf8b237c9e79a664444437357978b12dcd026" => :yosemite
    sha1 "15048c2a931ba8b16253854807c8e2f94d86af38" => :mavericks
    sha1 "8a518138395fa57d306212d935fb1c0088d065e0" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'libimobiledevice'

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
