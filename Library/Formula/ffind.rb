require 'formula'

class Ffind < Formula
  homepage 'https://github.com/sjl/friendly-find'
  url 'https://github.com/sjl/friendly-find/tarball/v0.3.1'
  sha1 '891207067c0d8715b48e91a52ff815aa73d7e139'

  def install
    bin.install "ffind"
  end

  def test
    system "ffind"
  end
end
