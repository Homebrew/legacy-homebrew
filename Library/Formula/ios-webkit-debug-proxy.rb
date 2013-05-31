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
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.3.tar.gz'
  sha1 'bc4c240497148a232054be18269368c92deb2a75'

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
