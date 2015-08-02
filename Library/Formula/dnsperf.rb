require 'formula'

class Dnsperf < Formula
  desc "Measure DNS performance by simulating network conditions"
  homepage 'http://nominum.com/support/measurement-tools/'
  url 'ftp://ftp.nominum.com/pub/nominum/dnsperf/2.0.0.0/dnsperf-src-2.0.0.0-1.tar.gz'
  sha1 'a0cf8f95de821a9ca1b7f8001e5ef7334e968540'

  depends_on 'bind'
  depends_on 'libxml2'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/dnsperf -h"
    system "#{bin}/resperf -h"
  end
end
