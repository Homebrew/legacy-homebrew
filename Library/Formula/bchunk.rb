require 'formula'

class Bchunk < Formula
  homepage 'http://he.fi/bchunk/'
  url 'http://he.fi/bchunk/bchunk-1.2.0.tar.gz'
  sha1 'a328e4665eb5e51df63d8d27d1d75ecc74bdef9e'

  def install
    system "make"
    bin.install 'bchunk'
    man1.install 'bchunk.1'
  end
end
