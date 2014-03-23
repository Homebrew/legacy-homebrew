require 'formula'

class Makeicns < Formula
  homepage 'http://bitbucket.org/mkae/makeicns'
  url 'https://bitbucket.org/mkae/makeicns/downloads/makeicns-1.4.10a.tar.bz2'
  sha1 '2a3b1229781516c8cc36089bf09729d5c17ac17c'
  head 'https://bitbucket.org/mkae/makeicns', :using => :hg

  patch :p0 do
    url "https://trac.macports.org/export/114372/trunk/dports/graphics/makeicns/files/patch-IconFamily.m.diff"
    sha1 "da9a741752fed1823a3ca78f6a84181765a82b8a"
  end

  def install
    system "make"
    bin.install "makeicns"
  end
end
