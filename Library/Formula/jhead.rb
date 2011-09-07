require 'formula'

class Jhead < Formula
  url 'http://www.sentex.net/~mwandel/jhead/jhead-2.90.tar.gz'
  homepage 'http://www.sentex.net/~mwandel/jhead/'
  md5 '661effa9420bb92cb99ced697c5a177f'

  def install
    system "make"
    system "chmod +x jhead"
    bin.install "jhead"
  end
end
