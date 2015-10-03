class Net6 < Formula
  desc "C++ library for network-based applications"
  homepage "http://gobby.0x539.de"
  url "http://releases.0x539.de/net6/net6-1.3.14.tar.gz"
  sha256 "155dd82cbe1f8354205c79ab2bb54af4957047422250482596a34b0e0cc61e21"
  revision 2

  bottle do
    cellar :any
    sha256 "b4980a4d4a672aa4e8b4c16811655ad02a9791ccd774546c733beefc196ee942" => :el_capitan
    sha256 "9b01f2c129e90c574e78914df3c4b59bc9e5eae49e4c20b60e298781453f37aa" => :yosemite
    sha256 "06237c8cd6a00445e1ea705d072a4b7241f7a570c18557b550b6983ba85e0158" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libsigc++"

  needs :cxx11

  def install
    ENV.cxx11
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end
