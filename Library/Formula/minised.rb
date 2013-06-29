require 'formula'

class Minised < Formula
  homepage 'http://www.exactcode.de/site/open_source/minised/'
  url 'http://dl.exactcode.de/oss/minised/minised-1.13.tar.gz'
  sha1 '3b718ce86c48047d1f5e8efcee8dd69a7a9dbac5'

  def install
    system "make" # separate steps or it won't build the binary
    system "make", "DESTDIR=#{prefix}", "PREFIX=", "install"
  end
end
