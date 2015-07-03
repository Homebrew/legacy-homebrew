require 'formula'

class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.5.tar.gz'
  sha1 '34f6325200700ccbd8c190b0c6835beb1396303d'

  bottle do
    cellar :any
    sha1 "0c7419ab91dc1bc47c664aada5712b2367c9196c" => :yosemite
    sha1 "cd348f6486cc83e8a1502acc3a7f2550826e0a9a" => :mavericks
    sha1 "7d6b999f36569825be410869f38c345a1c287ddb" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on 'libtool' => :build
  depends_on 'pkg-config' => :build
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
