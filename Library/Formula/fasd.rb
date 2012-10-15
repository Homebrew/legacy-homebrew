require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/1.0.1'
  sha1 'c7df4c99b3f2b85b366a88513b695b01a8ba8907'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
