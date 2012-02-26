require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/0.5.4'
  md5 '9f051346463f19771d64c6a31a85a22b'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
