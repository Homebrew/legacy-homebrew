class Libgphoto2 < Formula
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.6/libgphoto2-2.5.6.tar.bz2"
  sha1 "260cc57751a4598dd56564b4ab1e06a74442ee38"

  bottle do
    revision 1
    sha1 "e5328c0af1095854562796d6cda6a876fa32a516" => :yosemite
    sha1 "1feb2f99709d1c802a2a82c89d8aee643b9d6a79" => :mavericks
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :run
  depends_on "libusb-compat"
  depends_on "gd"
  depends_on "libexif" => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "CFLAGS=-D_DARWIN_C_SOURCE"
    system "make install"
  end
end
