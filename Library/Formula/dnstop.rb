class Dnstop < Formula
  desc "Console tool to analyze DNS traffic"
  homepage "http://dns.measurement-factory.com/tools/dnstop/index.html"
  url "http://dns.measurement-factory.com/tools/dnstop/src/dnstop-20140915.tar.gz"
  sha256 "b4b03d02005b16e98d923fa79957ea947e3aa6638bb267403102d12290d0c57a"

  bottle do
    cellar :any
    sha256 "5ce413357565d9ba4279ed10eb22fd83e49e5fcfd46fe350b8d1d21b4d2cce61" => :mavericks
    sha256 "52cc4b54da7e8b49c9b57aea5db74a39b7b56d9b1ee5660620a061a639ecd861" => :mountain_lion
    sha256 "9533d246369a9c792cdec3ca29680773b88857d1faa68d1fa1f5437301b01c4b" => :lion
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    bin.install "dnstop"
    man8.install "dnstop.8"
  end
end
