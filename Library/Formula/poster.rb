require 'formula'

class Poster < Formula
  homepage 'http://schrfr.github.com/poster/'
  url 'https://github.com/schrfr/poster/tarball/1.0.0'
  md5 'c76de471156c65b8182de0e6f5c8f1b5'

  def install
    system "make"
    bin.install 'poster'
    man1.install 'poster.1'
  end
end
