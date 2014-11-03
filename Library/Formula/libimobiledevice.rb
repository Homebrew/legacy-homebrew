require "formula"

class Libimobiledevice < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.6.tar.bz2"
  sha1 "3016bf1241bc5a77a621c49d82d71bb8f32905e4"
  revision 1

  bottle do
    cellar :any
    revision 2
    sha1 "3798eed87ba1f8eac58fa4ceb5fc53b0c84c3612" => :yosemite
    sha1 "89ef56d797d9ed5ff2c4cd5477814473c19cf3ab" => :mavericks
    sha1 "4d7720e3cffd8a5d555f6c013475abee9e06ceb6" => :mountain_lion
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
