require "formula"

class Ideviceinstaller < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha1 "5e2c47b9e6ac6d610b7bfe5186c8e84536549ce4"

  bottle do
    cellar :any
    sha1 "3c255cc07204fe0b7b9715cc8e9f5caf46f496e9" => :yosemite
    sha1 "883165e904a0d4dde166597efc1f709598f2a8b8" => :mavericks
    sha1 "23fbfb97b7ce046ac3348ad47914d28bd2165ba9" => :mountain_lion
  end

  head do
    url "http://git.sukimashita.com/ideviceinstaller.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libimobiledevice"
  depends_on "libzip"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/ideviceinstaller --help |grep -q ^Usage"
  end
end
