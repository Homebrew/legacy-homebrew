require 'formula'

class Makeicns < Formula
  homepage 'http://bitbucket.org/mkae/makeicns'
  url 'https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.9.tar.bz2'
  sha1 '02d393bad00a138dbba7b08d741e8d40a79e6c0f'
  head 'https://bitbucket.org/mkae/makeicns', :using => :hg

  def install
    system "make"
    bin.install "makeicns"
  end
end
