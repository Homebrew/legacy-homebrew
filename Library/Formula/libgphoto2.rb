class Libgphoto2 < Formula
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.6/libgphoto2-2.5.6.tar.bz2"
  sha1 "260cc57751a4598dd56564b4ab1e06a74442ee38"

  bottle do
    sha1 "f6115d0ea66a9acc4186f2976b662832d1469517" => :yosemite
    sha1 "e6d052ea0aa12a58c950fcf0daea1288779714ab" => :mavericks
    sha1 "0899334514b196fec3bdcc603f195eef2386205d" => :mountain_lion
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
