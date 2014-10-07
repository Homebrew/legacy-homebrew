require "formula"

class Powerman < Formula
  homepage "http://code.google.com/p/powerman/"
  url "https://github.com/chaos/powerman/releases/download/2.3.20/powerman-2.3.20.tar.gz"
  sha256 "a4b0858d1214aab18e2673596b00ac9bad976cb7b777209e10732467c3551b88"

  bottle do
    sha1 "13cb32e10f668dbb4aa5c45f875b1f6eefe51add" => :mavericks
    sha1 "01782db5105f648477202f5d6864a16f84024401" => :mountain_lion
    sha1 "750e16ba1c0f6bed9d63b8c89c7e4a5484276723" => :lion
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
    args = ["--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--localstatedir=#{HOMEBREW_PREFIX}/var"
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
