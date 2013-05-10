require 'formula'

class LionOrNewer < Requirement
  fatal true

  satisfy MacOS.version >= :lion

  def message
    "ios-webkit-debug-proxy requires Mac OS X 10.7 (Lion) or newer."
  end
end

class IosWebkitDebugProxy < Formula
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.2.tar.gz'
  sha1 'b0e72f586263da2e20c587fc479b8005edf396cf'

  depends_on LionOrNewer
  depends_on :autoconf => :build
  depends_on :automake => :build
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
