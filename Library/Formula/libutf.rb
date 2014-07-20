require 'formula'

class Libutf < Formula
  homepage 'http://swtch.com/plan9port/unix/'
  url 'http://swtch.com/plan9port/unix/libutf-20110530.tgz'
  sha256 '7789326c507fe9c07ade0731e0b0da221385a8f7cd1faa890af92a78a953bf5e'

  bottle do
    cellar :any
    sha1 "40adfa6e9c0dee0732d10052ddfc772cadbcef00" => :mavericks
    sha1 "e4071ba620b492c667e78f6ce72be094ead85fd0" => :mountain_lion
    sha1 "d9ea75fb3bc377d9719bb039f1fdec2051ff611b" => :lion
  end

  def install
    # Make.Darwin-386 is the only Makefile they have
    inreplace 'Makefile' do |f|
      f.gsub! 'man/man7', 'share/man/man7'
      f.gsub! 'Make.$(SYSNAME)-$(OBJTYPE)', 'Make.Darwin-386'
    end
    system "make", "PREFIX=#{prefix}", "install"
  end
end
