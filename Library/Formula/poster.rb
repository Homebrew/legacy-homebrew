require 'formula'

class Poster < Formula
  homepage 'http://schrfr.github.com/poster/'
  url 'https://github.com/schrfr/poster/tarball/1.0.0'
  sha1 '30492aa7e9aa4242b4540b9b60df9538c21fcf7e'

  def install
    system "make"
    bin.install 'poster'
    man1.install 'poster.1'
  end
end
