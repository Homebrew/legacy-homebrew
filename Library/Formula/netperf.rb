require "formula"

class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "http://netperf.org"
  url "ftp://ftp.netperf.org/netperf/netperf-2.7.0.tar.bz2"
  sha256 "842af17655835c8be7203808c3393e6cb327a8067f3ed1f1053eb78b4e40375a"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
