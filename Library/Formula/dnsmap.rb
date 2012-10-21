require 'formula'

class Dnsmap < Formula
  url 'http://dnsmap.googlecode.com/files/dnsmap-0.30.tar.gz'
  homepage 'http://code.google.com/p/dnsmap/'
  sha1 'a9a8a17102825510d16c1f8af33ca74407c18c70'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "BINDIR=#{bin}", "install"
  end
end
