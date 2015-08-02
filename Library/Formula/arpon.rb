require "formula"

class Arpon < Formula
  desc "Handler daemon to secure the ARP protocol from MITM attacks"
  homepage "http://arpon.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/arpon/arpon/ArpON-2.7.2.tar.gz"
  sha1 "75e4b1f2a2c18e4982fc5797547d52a13194f81d"

  head "git://git.code.sf.net/p/arpon/code"

  bottle do
    sha1 "6e172972a05a57cf5023c9e74a25c8269cdf6fb4" => :yosemite
    sha1 "acba3bde1ac94612b290aba641e70588a983a709" => :mavericks
    sha1 "6a5938797d1b6e8b04827bf7a920555c55468fc8" => :mountain_lion
  end

  depends_on "cmake" => :build
  depends_on "libdnet"
  depends_on "libnet"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end
end
