require 'formula'

class Ondir < Formula
  homepage 'http://swapoff.org/ondir.html'
  head 'https://github.com/alecthomas/ondir.git'
  url 'http://swapoff.org/files/ondir/ondir-0.2.3.tar.gz'
  sha1 '372962799612d925c1edd6eaca774dc971438bbe'

  def install
    system "make"
    system "make", "PREFIX=#{prefix}", "install"
  end
end
