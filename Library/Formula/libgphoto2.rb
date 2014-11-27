require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.5/libgphoto2-2.5.5.tar.bz2"
  sha1 "9660c1ac44584badbf83511feeb808fb4519adc2"

  bottle do
    revision 1
    sha1 "e5328c0af1095854562796d6cda6a876fa32a516" => :yosemite
    sha1 "1feb2f99709d1c802a2a82c89d8aee643b9d6a79" => :mavericks
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :run
  depends_on 'libusb-compat'
  depends_on 'gd'
  depends_on 'libexif' => :optional

  # Fixes build issues when using clang (bug #987).
  #  * http://sourceforge.net/p/gphoto/bugs/987/
  patch :p0 do
    url "http://sourceforge.net/p/gphoto/bugs/_discuss/thread/e52254c4/a5b3/attachment/xx.pat"
    sha1 "da1cd2e0fcc49a0fe374739ee15b448e9c04428c"
  end

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "CFLAGS=-D_DARWIN_C_SOURCE"
    system "make install"
  end
end
