class DublinTraceroute < Formula
  desc "Dublin Traceroute is a NAT-aware multipath tracerouting tool"
  homepage "https://dublin-traceroute.net"
  url "https://github.com/insomniacslk/dublin-traceroute/archive/v0.2.tar.gz"
  version "0.2"
  sha256 "ca1fdd375d2c2ce3f51f812570cbfe21e9d1244f00f07f052342031800868a6d"
  head "https://github.com/insomniacslk/dublin-traceroute.git"

  depends_on "cmake" => :build
  depends_on "libtins" => "3.4"
  depends_on "jsoncpp"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    system "dublin-traceroute"
  end
end
