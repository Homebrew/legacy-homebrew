class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "http://libmodbus.org"
  url "http://libmodbus.org/site_media/build/libmodbus-3.1.1.tar.gz"
  sha256 "76d93aff749d6029f81dcf1fb3fd6abe10c9b48d376f3a03a4f41c5197c95c99"

  bottle do
    cellar :any
    revision 1
    sha1 "49132fcf200e02792b898857bce7630de3d4d3ce" => :yosemite
    sha1 "a39c4927f9794f0a9af374249f2f4598c2d2f5d5" => :mavericks
    sha1 "a4ef5c2d803aaddfbe8f79d819d13c148f5bda0c" => :mountain_lion
  end

  head do
    url "https://github.com/stephane/libmodbus.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./autogen.sh" if build.head?
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end
end
