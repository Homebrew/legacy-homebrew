class Arpon < Formula
  desc "Handler daemon to secure the ARP protocol from MITM attacks"
  homepage "http://arpon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arpon/arpon/ArpON-2.7.2.tar.gz"
  sha256 "99adf83e4cdf2eda01601a60e2e1a611b5bce73865745fe67774c525c5f7d6d0"

  head "git://git.code.sf.net/p/arpon/code"

  bottle do
    sha256 "46c7a733c4252501027f173059d2a837a6b7662a4663c935174ff82da5889b06" => :yosemite
    sha256 "546156f55186bac2e18ff5ce88c784a82992c55919f41d9c599afc3d7abc6917" => :mavericks
    sha256 "89973683f88c5c93e95a1b25d2d230f16855a8b3705a9d0f560b650060b1005c" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libdnet"
  depends_on "libnet"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
