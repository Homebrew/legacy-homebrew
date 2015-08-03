class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage "http://nominum.com/support/measurement-tools/"
  url "ftp://ftp.nominum.com/pub/nominum/dnsperf/2.0.0.0/dnsperf-src-2.0.0.0-1.tar.gz"
  sha256 "23d486493f04554d11fca97552e860028f18c5ed6e35348e480a7448fa8cfaad"

  depends_on "bind"
  depends_on "libxml2"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf -h"
    system "#{bin}/resperf -h"
  end
end
