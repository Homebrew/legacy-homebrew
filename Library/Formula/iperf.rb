require 'formula'

class Iperf < Formula
  homepage "http://software.es.net/iperf"
  url "https://github.com/esnet/iperf/archive/3.0.5.tar.gz"
  sha1 "4ebc5bf6456527cdf6d902f8cd810169bc00711b"

  bottle do
    cellar :any
    sha1 "ce3cc45d64a0be38f489d96bb9c816e8ef1ded77" => :mavericks
    sha1 "831b48b0a1eb3822323e637bfb29df1da31df7ff" => :mountain_lion
    sha1 "a11c989cfaaa79438ca6c77ec9d038a139562692" => :lion
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
