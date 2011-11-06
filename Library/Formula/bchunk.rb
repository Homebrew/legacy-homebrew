require 'formula'

class Bchunk < Formula
  url 'http://he.fi/bchunk/bchunk-1.2.0.tar.gz'
  homepage 'http://he.fi/bchunk/'
  md5 '6a613da3f34f9a303f202d2e9731d231'

  def install
    system "make"
    bin.install 'bchunk'
    man1.install 'bchunk.1'
  end
end
