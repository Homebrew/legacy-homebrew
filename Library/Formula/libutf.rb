require 'formula'

class Libutf < Formula
  url 'http://swtch.com/plan9port/unix/libutf.tgz'
  version '1.0'
  homepage 'http://swtch.com/plan9port/unix/'
  sha256 '7789326c507fe9c07ade0731e0b0da221385a8f7cd1faa890af92a78a953bf5e'

  def install
    inreplace 'Makefile', 'man/man7', 'share/man/man7'
    system "make", "PREFIX=#{prefix}", "install"
  end
end
