require "formula"

class Dnstop < Formula
  homepage "http://dns.measurement-factory.com/tools/dnstop/index.html"
  url "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
  sha1 "af1567d6b53e8be697b884508a2a3a0edbea5e01"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "dnstop"
    man8.install "dnstop.8"
  end

end
