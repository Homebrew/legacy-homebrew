require "formula"

class Powerman < Formula
  homepage "http://code.google.com/p/powerman/"
  url "https://github.com/chaos/powerman/releases/download/2.3.20/powerman-2.3.20.tar.gz"
  sha256 "a4b0858d1214aab18e2673596b00ac9bad976cb7b777209e10732467c3551b88"
  revision 1

  bottle do
    sha1 "8885a67eba6e20904ba15c10256738eb30d5a53d" => :yosemite
    sha1 "a1ae6b1798c6b141a716d47d26e75882beb970fc" => :mavericks
    sha1 "fc67de36f5e2035c61d0877bc1477886ab30ab35" => :mountain_lion
  end

  head do
    url "https://github.com/chaos/powerman.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  option "without-curl", "Omits httppower"
  option "with-net-snmp", "Builds snmppower"

  depends_on "curl" => :recommended
  depends_on "net-snmp" => :optional
  depends_on "genders" => :optional

  def install
    args = [
      "--disable-dependency-tracking",
      "--prefix=#{prefix}",
      "--localstatedir=#{var}"
    ]

    args << (build.with?("curl") ? "--with-httppower" : "--without-httppower")
    args << (build.with?("net-snmp") ? "--with-snmppower" : "--without-snmppower")
    args << (build.with?("genders") ? "--with-genders" : "--without-genders")
    args << "--with-ncurses"
    args << "--without-tcp-wrappers"

    system "./autogen.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{sbin}/powermand", "-h"
  end
end
