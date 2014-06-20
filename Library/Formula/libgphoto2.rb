require 'formula'

class Libgphoto2 < Formula
  homepage 'http://www.gphoto.org/proj/libgphoto2/'
  url 'https://downloads.sourceforge.net/project/gphoto/libgphoto/2.5.4/libgphoto2-2.5.4.tar.bz2'
  sha1 'f9ada3e1a54a3723ecbf0bc270cdfd6da20cf90c'

  bottle do
    sha1 "7f76dcbb304ecf8afd5df4fb7032b48b1044f162" => :mavericks
    sha1 "f14565e700e13fe5b2bcb9568cd1f67fc1ee6a1d" => :mountain_lion
    sha1 "d6fd1dccbd5f4ab6d2b192d02325f91a3f20f1e6" => :lion
  end

  option :universal

  depends_on 'pkg-config' => :build
  depends_on 'libtool' => :run
  depends_on 'libusb-compat'
  depends_on 'gd'
  depends_on 'libexif' => :optional

  def install
    ENV.universal_binary if build.universal?
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "CFLAGS=-D_DARWIN_C_SOURCE"
    system "make install"
  end
end
