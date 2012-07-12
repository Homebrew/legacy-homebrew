require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/0.7.1'
  sha1 '73c0c612e7e21d440636cc280b3dd64b33772af2'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
