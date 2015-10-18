class Libftdi0 < Formula
  desc "Library to talk to FTDI chips"
  homepage "https://www.intra2net.com/en/developer/libftdi"
  url "https://www.intra2net.com/en/developer/libftdi/download/libftdi-0.20.tar.gz"
  sha256 "3176d5b5986438f33f5208e690a8bfe90941be501cc0a72118ce3d338d4b838e"

  bottle do
    cellar :any
    revision 2
    sha256 "8fbc5ef456600b919430d86dd4e7090ae1f1064e4a51d631ab9bd7b39887ead2" => :el_capitan
    sha256 "92ecdb3a110e1abcba05561f0def8e573d1f8174d4e04247375dd5cd47d3bc24" => :yosemite
    sha256 "29d786dcb87e4251c4cbd25c0d5e215eb248b74304f175054b31cbd6a464c071" => :mavericks
  end

  conflicts_with "cspice", :because => "both install `simple` binaries"
  conflicts_with "openhmd", :because => "both install `simple` binaries"

  depends_on "libusb-compat"

  def install
    mkdir "libftdi-build" do
      system "../configure", "--prefix=#{prefix}"
      system "make"
      system "make", "install"
    end
  end
end
