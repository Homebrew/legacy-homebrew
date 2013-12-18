require 'formula'

class Phoon < Formula
  homepage 'http://www.acme.com/software/phoon/'
  url 'http://www.acme.com/software/phoon/phoon_29jun2005.tar.gz'
  version '03A'
  sha1 'd646af184b83e1a4104fe82588daadae2938e08c'

  def install
    system "make"
    bin.install 'phoon'
    man1.install 'phoon.1'
  end
end
