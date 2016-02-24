class Ideviceinstaller < Formula
  desc "Cross-platform library and tools for communicating with iOS devices"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/ideviceinstaller-1.1.0.tar.bz2"
  sha256 "0821b8d3ca6153d9bf82ceba2706f7bd0e3f07b90a138d79c2448e42362e2f53"
  revision 2

  bottle do
    cellar :any
    sha256 "b7eeb31bbff843e910d528adbcae9c2351f4ac6323fa21afd9d4ae65677dad64" => :el_capitan
    sha256 "87ae074f7e75366be0d3a5ead0e7da2763eb78ad98fd4bc10b37c353dc738ea2" => :yosemite
    sha256 "b25013280c201c86157f124841d71140570f7fe47896657b8e2a3e6e22530e92" => :mavericks
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
