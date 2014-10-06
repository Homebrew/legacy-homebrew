require "formula"

class Dnstop < Formula
  homepage "http://dns.measurement-factory.com/tools/dnstop/index.html"
  url "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
  sha1 "af1567d6b53e8be697b884508a2a3a0edbea5e01"

  bottle do
    cellar :any
    sha1 "b46e65deaf30b6bb4f991cfa9aaeaee95417738f" => :mavericks
    sha1 "81b0e4d18732f08db7b922d328f006302ac4471d" => :mountain_lion
    sha1 "1ab48a2e5c2e6cc29e1be2d588a9e827accd2fe5" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "dnstop"
    man8.install "dnstop.8"
  end

end
