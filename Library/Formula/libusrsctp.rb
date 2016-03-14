class Libusrsctp < Formula
  desc "A portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://mirrorservice.org/sites/distfiles.macports.org/libusrsctp/libusrsctp-0.9.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/MacPorts/mpdistfiles/libusrsctp/libusrsctp-0.9.1.tar.gz"
  mirror "https://ftp.fau.de/macports/distfiles/libusrsctp/libusrsctp-0.9.1.tar.gz"
  sha256 "63a3abe5f1cb7ddde36cba09d32579b05a98badb06ff88fca87d024925c3ff16"

  bottle do
    cellar :any
    revision 1
    sha256 "7b34b5ecea1efc1010628940ae3dbba282c382447efdc95a421073c4968d49b8" => :yosemite
    sha256 "a1de98e0d6131039baaf32092eca8f77a954f2eb3c93f59f8b6bb7bcf2b03d4a" => :mavericks
    sha256 "420b3cd77be8a4db30463ce770c6927487d098c4c72fe2e72bb02f76dcb87e20" => :mountain_lion
  end

  head do
    url "https://github.com/sctplab/usrsctp.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end
