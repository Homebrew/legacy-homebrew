class Libimobiledevice < Formula
  desc "Library to communicate with iOS devices natively"
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.2.0.tar.bz2"
  sha256 "786b0de0875053bf61b5531a86ae8119e320edab724fc62fe2150cc931f11037"

  bottle do
    cellar :any
    sha256 "db353988bbd70c57409338bba501a618e1d92e920e409ef587a870618878c18c" => :el_capitan
    sha256 "b13e2074ea7c8bb541b9604c6f2cdcdf8b55ee53ddbb541c1b9905ec09bd0c1c" => :yosemite
    sha256 "1ef2fe290630098b2c868d10625af7bd66a244c21b0290ae611072ab3fdedb01" => :mavericks
    sha256 "9b1c6444d223a9eb99dcade6ee8382a062701293b5e6ddaa11e23405e4d92977" => :mountain_lion
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
    system "make", "install"
  end
end
