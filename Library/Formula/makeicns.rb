require 'formula'

class Makeicns < Formula
  url 'https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.9.tar.bz2'
  head 'https://bitbucket.org/mkae/makeicns', :using => :hg
  md5 '795ec620f15bfcebb5246319c1a96eab'
  homepage 'http://bitbucket.org/mkae/makeicns'

  def install
    system "make"
    bin.install "makeicns"
  end
end
