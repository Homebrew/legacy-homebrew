require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/0.5.3'
  md5 '8c88e903c64b28de0102751153fa04f4'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
