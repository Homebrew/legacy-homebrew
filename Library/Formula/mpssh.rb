require 'formula'

class Mpssh < Formula
  homepage 'https://github.com/ndenev/mpssh'
  url 'http://downloads.sourceforge.net/project/mpssh/mpssh/1.1/mpssh-1.1.tgz'
  sha1 'dbd2f9e85db58233ba8ce11d2cd6741ff15108af'

  def install
    system "make"
    bin.install "mpssh"
  end

  def test
    system "mpssh"
  end
end
