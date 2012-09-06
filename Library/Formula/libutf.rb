require 'formula'

class Libutf < Formula
  homepage 'http://swtch.com/plan9port/unix/'
  url 'http://swtch.com/plan9port/unix/libutf-20110530.tgz'
  sha256 '7789326c507fe9c07ade0731e0b0da221385a8f7cd1faa890af92a78a953bf5e'

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace 'Makefile' do |f|
      f.gsub! 'man/man7', 'share/man/man7'
      f.gsub! 'Make.$(SYSNAME)-$(OBJTYPE)', 'Make.Darwin-386'
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
