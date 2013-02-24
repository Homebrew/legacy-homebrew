require 'formula'

class Nuttcp < Formula
  homepage 'http://www.nuttcp.net/nuttcp'
  url 'http://lcp.nrl.navy.mil/nuttcp/nuttcp-6.1.2.tar.bz2'
  sha1 '329fcc3c0b75db18b7b4d73962992603f9ace9ca'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}"
    bin.install 'nuttcp-6.1.2' => 'nuttcp'
    man8.install 'nuttcp.cat' => 'nuttcp.8'
  end
end
