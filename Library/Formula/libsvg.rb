class Libsvg < Formula
  desc "Library for SVG files"
  homepage "http://cairographics.org/"
  url "http://cairographics.org/snapshots/libsvg-0.1.4.tar.gz"
  sha256 "4c3bf9292e676a72b12338691be64d0f38cd7f2ea5e8b67fbbf45f1ed404bc8f"
  revision 1

  bottle do
    cellar :any
    revision 1
    sha256 "4e7903c15847c2d07a2bdf16d6ddad5a0191ef452cf7733624703fd1b5fd7859" => :el_capitan
    sha1 "f81bd41636efb5f9bca9668e0d1eba49f2df5668" => :yosemite
    sha1 "7666fa071f1f53c8b680be546b8801cb3067f5a2" => :mavericks
    sha1 "a6644f62ac2844f1b73ad26febb49958a413a54f" => :mountain_lion
  end

  depends_on "libpng"
  depends_on "pkg-config" => :build
  depends_on "jpeg"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
