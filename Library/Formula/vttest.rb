require 'formula'

class Vttest < Formula
  homepage 'http://invisible-island.net/vttest/'
  url 'ftp://invisible-island.net/vttest/vttest-20120603.tgz'
  version '2.7-20120603'
  sha1 '7d4eae046049bdf7cb086ebba130b804a4972492'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end
