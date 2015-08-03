class Dnstop < Formula
  desc "Console tool to analyze DNS traffic"
  homepage "http://dns.measurement-factory.com/tools/dnstop/index.html"
  url "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
  sha256 "b4b03d02005b16e98d923fa79957ea947e3aa6638bb267403102d12290d0c57a"

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
