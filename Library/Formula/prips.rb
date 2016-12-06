require 'formula'

class Prips < Formula
  homepage 'http://devel.ringlet.net/sysutils/prips/'
  url 'http://devel.ringlet.net/sysutils/prips/prips-0.9.9.tar.gz'
  sha1 '8e11c993f8525b2345cfbfb15801364d5a65a7dc'

  def install
    system "make"
    bin.install "prips"
    lib.install "prips.o"
    include.install "prips.h"
    man1.install "prips.1"
  end

  def test
    system "prips"
  end
end
