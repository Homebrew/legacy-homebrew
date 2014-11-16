require 'formula'

class Poster < Formula
  homepage 'http://schrfr.github.io/poster/'
  url 'https://github.com/schrfr/poster/archive/1.0.0.tar.gz'
  sha1 '20846c17fc0c266caecf82b24cbe7906999a410c'

  def install
    system "make"
    bin.install 'poster'
    man1.install 'poster.1'
  end
end
