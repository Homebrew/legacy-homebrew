class Libgphoto2 < Formula
  desc "Gphoto2 digital camera library"
  homepage "http://www.gphoto.org/proj/libgphoto2/"
  url "https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.7/libgphoto2-2.5.7.tar.bz2"
  sha1 "0f0ebe1c953eab598c6a53477b81be762ab9047f"

  bottle do
    sha1 "e3daec0e8f32cd4314560abc4a582832278c92b7" => :yosemite
    sha1 "d4f9d264941a44585b17e288a5b91b0c53eb08f4" => :mavericks
    sha1 "619ef05556816f98e84cfc900e74cf1ee8fd95f7" => :mountain_lion
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
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
