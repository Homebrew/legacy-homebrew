require "formula"

class Nut < Formula
  homepage "http://www.networkupstools.org"
  url "http://www.networkupstools.org/source/2.7/nut-2.7.2.tar.gz"
  sha256 "4d5365359b059d96dfcb77458f361a114d26c84f1297ffcd0c6c166f7200376d"
  revision 1

  bottle do
    sha1 "21681b1e72256bddffaf579b3ed7097c48ed14cd" => :yosemite
    sha1 "e21f9d0b15040138ece75160b1d9c72680611fc3" => :mavericks
    sha1 "691e803014feeb6267fb50784848cb698912ae54" => :mountain_lion
  end

  head do
    url "https://github.com/networkupstools/nut.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-serial", "Omits serial drivers"
  option "without-libusb-compat", "Omits USB drivers"
  option "with-dev", "Includes dev headers"
  option "with-net-snmp", "Builds SNMP support"
  option "with-neon", "Builds XML-HTTP support"
  option "with-powerman", "Builds powerman PDU support"
  option "with-freeipmi", "Builds IPMI PSU support"
  option "with-cgi", "Builds CGI wrappers"
  option "with-libltdl", "Adds dynamic loading support of plugins using libltdl"

  depends_on "pkg-config" => :build
  depends_on "libusb-compat" => :recommended
  depends_on "net-snmp" => :optional
  depends_on "neon" => :optional
  depends_on "powerman" => :optional
  depends_on "freeipmi" => :optional
  depends_on "openssl"
  depends_on "libtool" => :build
  depends_on "gd" if build.with? "cgi"

  def install
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--localstatedir=#{var}",
            "--without-doc",
            "--without-avahi",
            "--with-macosx_ups",
            "--with-openssl",
            "--without-nss",
            "--without-wrap"
    ]
    args << (build.with?("serial") ? "--with-serial" : "--without-serial")
    args << (build.with?("libusb") ? "--with-usb" : "--without-usb")
    args << (build.with?("dev") ? "--with-dev" : "--without-dev")
    args << (build.with?("net-snmp") ? "--with-snmp" : "--without-snmp")
    args << (build.with?("neon") ? "--with-neon" : "--without-neon")
    args << (build.with?("powerman") ? "--with-powerman" : "--without-powerman")
    args << (build.with?("ipmi") ? "--with-ipmi" : "--without-ipmi")
    args << "--with-freeipmi" if build.with? "ipmi"
    args << (build.with?("libltdl") ? "--with-libltdl" : "--without-libltdl")
    args << (build.with?("cgi") ? "--with-cgi" : "--without-cgi")

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
