require 'formula'

class Eatmemory < Formula
  homepage 'https://github.com/julman99/eatmemory'
  url 'https://github.com/julman99/eatmemory/tarball/v0.1.2'
  version '0.1.2'
  sha1 'a44af4a2b716fcf4813327ddcc08b1e303683df5'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end
