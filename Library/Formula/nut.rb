require "formula"

class Nut < Formula
  homepage "http://www.networkupstools.org"
  url "http://www.networkupstools.org/source/2.7/nut-2.7.2.tar.gz"
  sha256 "4d5365359b059d96dfcb77458f361a114d26c84f1297ffcd0c6c166f7200376d"

  bottle do
    sha1 "4a37cf6350e56dfbbb80a7bfb03f3f6aa804e36a" => :mavericks
    sha1 "467ed9df7b3aeae35060d5fecfe229caeba62180" => :mountain_lion
    sha1 "4ab46368434117fbb380d90463295fbb8f254ef9" => :lion
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
            "--localstatedir=#{HOMEBREW_PREFIX}/var",
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
    args << (build.with?("snmp") ? "--with-snmp" : "--without-snmp")
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
