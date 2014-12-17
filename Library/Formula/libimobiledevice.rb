class Libimobiledevice < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.7.tar.bz2"
  sha1 "ac47ba39e7f8d8cb9379756773ece30458b93c80"

  bottle do
    cellar :any
    revision 1
    sha1 "39f7ff7216e593d6afe2737ed42b30a8565060d5" => :yosemite
    sha1 "bcdb212d83c8b863e2ac81bd560cbbb3b6268bc2" => :mavericks
    sha1 "e288c30272a07b9dc2fce2f804a4c19d5d3971b1" => :mountain_lion
  end

  head do
    url "http://git.sukimashita.com/libimobiledevice.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libxml2"
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "openssl"

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make install"
  end
end
