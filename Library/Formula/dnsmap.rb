require 'formula'

class Dnsmap < Formula
  url 'http://dnsmap.googlecode.com/files/dnsmap-0.30.tar.gz'
  homepage 'http://code.google.com/p/dnsmap/'
  md5 '7f341361622db147906700d37af46e06'

  def install
    system "make", "CC=#{ENV.cc}", "CFLAGS=#{ENV.cflags}", "BINDIR=#{bin}", "install"
  end
end
