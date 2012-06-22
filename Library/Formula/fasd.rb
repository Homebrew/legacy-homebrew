require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/0.5.5'
  md5 '7f56d9c37d3a590d8c920af56601e2de'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
