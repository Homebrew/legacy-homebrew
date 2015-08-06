require "formula"

class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage "http://netperf.org"
  url "ftp://ftp.netperf.org/netperf/netperf-2.7.0.tar.bz2"
  sha1 "415ecd4877cf8e24cefe6943564e511e6f1e2215"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
