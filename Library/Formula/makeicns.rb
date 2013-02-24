require 'formula'

class Makeicns < Formula
  homepage 'http://bitbucket.org/mkae/makeicns'
  url 'https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.10a.tar.bz2'
  sha1 '2a3b1229781516c8cc36089bf09729d5c17ac17c'
  head 'https://bitbucket.org/mkae/makeicns', :using => :hg

  def install
    system "make"
    bin.install "makeicns"
  end
end
