require 'formula'

class Rfcmarkup < Formula
  homepage 'http://tools.ietf.org/tools/rfcmarkup/'
  url 'http://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.101.tgz'
  sha1 'e0c6822185b5b2d73dc72e169d87fab9c50dc2a8'

  def install
    bin.install "rfcmarkup"
  end
end
