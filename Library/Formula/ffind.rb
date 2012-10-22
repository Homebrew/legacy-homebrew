require 'formula'

class Ffind < Formula
  homepage 'https://github.com/sjl/friendly-find'
  url 'https://github.com/sjl/friendly-find/tarball/v0.2.0'
  sha1 'b902ebb9966c1394628e52d0dea3b1ba7c421720'

  def install
    bin.install "ffind"
  end

  def test
    system "ffind"
  end
end
