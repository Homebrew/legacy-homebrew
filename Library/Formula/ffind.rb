require 'formula'

class Ffind < Formula
  homepage 'https://github.com/sjl/friendly-find'
  url 'https://github.com/sjl/friendly-find/tarball/v0.3.0'
  sha1 '4a5ea9de402a651ee784f46f9f0e9b0fd4f0a6b8'

  def install
    bin.install "ffind"
  end

  def test
    system "ffind"
  end
end
