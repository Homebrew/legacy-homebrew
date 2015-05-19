require 'formula'

class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage 'https://github.com/google/ios-webkit-debug-proxy'
  url 'https://github.com/google/ios-webkit-debug-proxy/archive/1.4.tar.gz'
  sha1 'e6d882182fe2fd8f5827a9289545cc7e9ebb25e7'
  revision 2

  bottle do
    cellar :any
    sha1 "0c7419ab91dc1bc47c664aada5712b2367c9196c" => :yosemite
    sha1 "cd348f6486cc83e8a1502acc3a7f2550826e0a9a" => :mavericks
    sha1 "7d6b999f36569825be410869f38c345a1c287ddb" => :mountain_lion
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
