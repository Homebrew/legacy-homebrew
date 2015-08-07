class IosWebkitDebugProxy < Formula
  desc "DevTools proxy for iOS devices"
  homepage "https://github.com/google/ios-webkit-debug-proxy"
  url "https://github.com/google/ios-webkit-debug-proxy/archive/1.5.tar.gz"
  sha256 "bf60eaed2395d74775e875e6c069ce398e37adbef8d56cb6a58faaec821343db"

  bottle do
    cellar :any
    sha256 "5b7f1a0c6a3980a71c7a17351a11c3b54b81b0a5e7692530ed9b6a26836c1f65" => :yosemite
    sha256 "e5376a0b9abea1af969cbb14416ccde34046b60e5fede0c45d7d5e2952deb295" => :mavericks
    sha256 "f5cd081364422f1053c15adce7bb82b4440cf488f7ba7068ef67dc6f4ffb936b" => :mountain_lion
  end

  depends_on :macos => :lion
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "libimobiledevice"

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
