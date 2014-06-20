require 'formula'

class N < Formula
  homepage 'https://github.com/visionmedia/n'
  head 'https://github.com/visionmedia/n.git'
  url 'https://github.com/visionmedia/n/archive/1.2.1.tar.gz'
  sha1 'c8a54313ee8ff43f3b6cdb03f140bc200f548f9f'

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end
end
