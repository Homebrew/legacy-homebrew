require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/archive/1.0.1.tar.gz'
  sha1 'aeb3f9c6f8f9e4355016e3255429bcad5c7a5689'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
