require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/0.5.5'
  sha1 '8ce380ab9e04b4cc14e79557fbb0e7b0ef4b61f7'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
