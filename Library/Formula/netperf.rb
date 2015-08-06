class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "http://netperf.org"
  url "ftp://ftp.netperf.org/netperf/netperf-2.7.0.tar.bz2"
  sha256 "842af17655835c8be7203808c3393e6cb327a8067f3ed1f1053eb78b4e40375a"

  bottle do
    cellar :any
    sha256 "12102c72722ff5a7a337414a41b6f3bc7fa67fd4dc32aadd84693c22907c99e8" => :yosemite
    sha256 "026fe8418ea6be50576850a9b3cde6a5a71a7d93924a1eb6b77cba88675b2a89" => :mavericks
    sha256 "4e0aa192670d1de341e77e0bd3af4b2cccc6a5b12a734e922e92c7b7d50f281d" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
