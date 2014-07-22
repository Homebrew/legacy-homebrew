require 'formula'

class Iperf < Formula
  homepage "http://software.es.net/iperf"
  url "https://github.com/esnet/iperf/archive/3.0.5.tar.gz"
  sha1 "4ebc5bf6456527cdf6d902f8cd810169bc00711b"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
