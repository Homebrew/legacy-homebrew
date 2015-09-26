class Nut < Formula
  desc "Network UPS Tools: Support for various power devices"
  homepage "http://www.networkupstools.org"
  url "http://www.networkupstools.org/source/2.7/nut-2.7.3.tar.gz"
  sha256 "ff44d95d06a51559a0a018eef7f8d17911c1002b6352a7d7580ff75acb12126b"

  bottle do
    sha256 "92af5c4593bfb1231c770ace968f80d42867883e66544a06c46cf26400bdec27" => :yosemite
    sha256 "9c7100a6f831b7e21615ab4e2551056abda2e7b0b72c4e697e499e1c7908198a" => :mavericks
    sha256 "e1a76ac63b98a306cb6dfd524a475d5127ba811c0cd96bf32da10d059b12a35a" => :mountain_lion
  end

  head do
    url "https://github.com/networkupstools/nut.git"
    depends_on "asciidoc" => :build
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
    if build.head?
      ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"
      system "./autogen.sh"
    end

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

    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/dummy-ups", "-L"
  end
end
