class Ideviceinstaller < Formula
  desc "Cross-platform library and tools for communicating with iOS devices"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 1

  bottle do
    cellar :any
    sha256 "f4bc3065ea5965fe26c793624b4d40fd7eef863c265c311f9c3b6fcf47ff641f" => :el_capitan
    sha1 "893e9e6cb97a2073bb0b42e9ae09cd5d085f6f0f" => :yosemite
    sha1 "e484976abf87bbf958c003b5f651db9329be862b" => :mavericks
    sha1 "7a8a684bb21b714c447fa484fa6cd4a8f6027313" => :mountain_lion
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
