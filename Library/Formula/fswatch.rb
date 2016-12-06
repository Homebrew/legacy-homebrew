require 'formula'

class Fswatch < Formula
  homepage 'https://github.com/alandipert/fswatch'
  url 'http://nodeload.github.com/alandipert/fswatch/tarball/r0.0.1'
  sha1 '54e322d958990d0ba54293628b0a345944c7b4f5'

  version '0.0.1'

  def install
    system "make"
    bin.install ['fswatch']
    lib.install ['fswatch.o']
  end

  def test
    false
  end
end
