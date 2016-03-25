class Libusrsctp < Formula
  desc "A portable SCTP userland stack"
  homepage "https://github.com/sctplab/usrsctp"
  url "https://mirrorservice.org/sites/distfiles.macports.org/libusrsctp/libusrsctp-0.9.1.tar.gz"
  mirror "https://mirror.csclub.uwaterloo.ca/MacPorts/mpdistfiles/libusrsctp/libusrsctp-0.9.1.tar.gz"
  mirror "https://ftp.fau.de/macports/distfiles/libusrsctp/libusrsctp-0.9.1.tar.gz"
  sha256 "63a3abe5f1cb7ddde36cba09d32579b05a98badb06ff88fca87d024925c3ff16"

  bottle do
    cellar :any
    revision 2
    sha256 "bf05bbef72c45daec3f682b9c12a4ad838ad5c02e1814cbfa837e610140988a3" => :el_capitan
    sha256 "7b681d68a1dca9792595dce4dc2d677e5a578ed5027dee6ba4dc312cd3f5119b" => :yosemite
    sha256 "a42402bb65451da92fd33b86ba33a4c1f75d8931830437d866d5298f3c2818cf" => :mavericks
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
