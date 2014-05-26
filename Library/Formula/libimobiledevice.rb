require "formula"

class Libimobiledevice < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.6.tar.bz2"
  sha1 "3016bf1241bc5a77a621c49d82d71bb8f32905e4"

  head "http://cgit.sukimashita.com/libimobiledevice.git"

  bottle do
    cellar :any
    sha1 "f34c0c45c2be50b1fed8eb40760462a7339fffcd" => :mavericks
    sha1 "b1abcc6f7bdc142d8f3da012cd94eddef42ef4a1" => :mountain_lion
    sha1 "0bcc31e491474f923c145b702dc7870ddf003fff" => :lion
  end

  depends_on "pkg-config" => :build
  depends_on "libtasn1"
  depends_on "libplist"
  depends_on "usbmuxd"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          # As long as libplist builds without Cython
                          # bindings, libimobiledevice must as well.
                          "--without-cython"
    system "make install"
  end
end
