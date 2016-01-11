class Libmodbus < Formula
  desc "Portable modbus library"
  homepage "http://libmodbus.org"
  url "http://libmodbus.org/site_media/build/libmodbus-3.1.1.tar.gz"
  sha256 "76d93aff749d6029f81dcf1fb3fd6abe10c9b48d376f3a03a4f41c5197c95c99"

  bottle do
    cellar :any
    revision 1
    sha256 "1fc2e425a2d7c42bd35364ee3ca41592940e6de7cab628824d0c5dd2cdcb98c6" => :yosemite
    sha256 "5633226af76d9e9b5eadc0dfa541da123c2ef9ac7dbb70b23dbbce3799581f17" => :mavericks
    sha256 "d316924c6dc8abd13c2e171577888c0ac569c426a6c32bd511531beb4da42758" => :mountain_lion
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
