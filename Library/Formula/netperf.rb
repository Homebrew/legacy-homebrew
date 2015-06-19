require 'formula'

class Netperf < Formula
  desc "Benchmarks performance of many different types of networking"
  homepage 'http://netperf.org'
  url 'ftp://ftp.netperf.org/netperf/netperf-2.6.0.tar.bz2'
  sha1 '3e1be4e7c3f7a838c4d5c00c6d20a619b320bfef'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/netperf -h | cat"
  end
end
