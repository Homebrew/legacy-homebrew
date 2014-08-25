require "formula"

class Libimobiledevice < Formula
  homepage "http://www.libimobiledevice.org/"
  url "http://www.libimobiledevice.org/downloads/libimobiledevice-1.1.6.tar.bz2"
  sha1 "3016bf1241bc5a77a621c49d82d71bb8f32905e4"
  revision 1

  head "http://cgit.sukimashita.com/libimobiledevice.git"

  bottle do
    cellar :any
    revision 1
    sha1 "33a77a7e631b3fd8188ffd6043afd1bc0d2a7ed8" => :mavericks
    sha1 "5d5302f4b79262902272caaaa66471d52b256488" => :mountain_lion
    sha1 "ba4c0f4864153cc916d0f6c9ebd20468c6db47ac" => :lion
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
