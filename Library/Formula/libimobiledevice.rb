require "formula"

class Libimobiledevice < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.7.tar.bz2"
  sha1 "ac47ba39e7f8d8cb9379756773ece30458b93c80"

  bottle do
    cellar :any
    sha1 "e8ad563ebccce97e0ac0c8f4b9b60236457df3af" => :yosemite
    sha1 "47a637a1e8315f6e8924c518e393c32dc8a04e7a" => :mavericks
    sha1 "163c63811713019e6040deff7ad1992691f00f08" => :mountain_lion
  end

  head do
    url "http://cgit.sukimashita.com/libimobiledevice.git"
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
