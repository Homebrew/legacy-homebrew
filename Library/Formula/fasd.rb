require 'formula'

class Fasd < Formula
  homepage 'https://github.com/clvv/fasd'
  url 'https://github.com/clvv/fasd/tarball/1.0.0'
  sha1 '4e8e39ea8847d8d9402634c60b6c4fbf461e71dd'

  def install
    bin.install 'fasd'
    man1.install 'fasd.1'
  end
end
