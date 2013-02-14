require 'formula'

class IosWebkitDebugProxy < Formula
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.0.tar.gz'
  sha1 '8540fae9dc74a333401d1b217802d760e038934b'

  depends_on :autoconf => :build
  depends_on 'libplist'
  depends_on 'usbmuxd'
  depends_on 'libimobiledevice'

  fails_with :clang do
    build 425
    cause 'syntax errors with clang.'
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
