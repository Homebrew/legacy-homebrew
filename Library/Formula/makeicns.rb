require 'formula'

class Makeicns < Formula
  homepage 'http://bitbucket.org/mkae/makeicns'
  url 'https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.9.tar.bz2'
  md5 '795ec620f15bfcebb5246319c1a96eab'
  head 'https://bitbucket.org/mkae/makeicns', :using => :hg

  def install
    system "make"
    bin.install "makeicns"
  end
end
