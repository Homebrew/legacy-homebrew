require 'formula'

class IosWebkitDebugProxy < Formula
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.4.tar.gz'
  sha1 'e6d882182fe2fd8f5827a9289545cc7e9ebb25e7'

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
