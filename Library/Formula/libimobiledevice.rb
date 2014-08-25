require "formula"

class Libimobiledevice < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.6.tar.bz2"
  sha1 "3016bf1241bc5a77a621c49d82d71bb8f32905e4"
  revision 1

  head "http://cgit.sukimashita.com/libimobiledevice.git"

  bottle do
    cellar :any
    sha1 "8e2b8852177d64b77a2b0f55a0690a75520ddd52" => :mavericks
    sha1 "8338602f988b0cfe097c1a68141d70b3f8715527" => :mountain_lion
    sha1 "79225f9bafe448f7964c50be8c95638b653294eb" => :lion
  end

  head do
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
