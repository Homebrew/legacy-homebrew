require 'formula'

class Gaffitter < Formula
  url 'http://downloads.sourceforge.net/project/gaffitter/gaffitter/0.6.0/gaffitter-0.6.0.tar.bz2'
  homepage 'http://gaffitter.sourceforge.net/'
  md5 'a4a0fa0b3eeeaf49624d2e1b78de3cff'

  def install
    system "make"
    bin.install "src/gaffitter"
  end
end
