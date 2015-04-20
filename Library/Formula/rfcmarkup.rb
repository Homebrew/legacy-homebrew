require 'formula'

class Rfcmarkup < Formula
  homepage 'http://tools.ietf.org/tools/rfcmarkup/'
  url 'http://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.106.tgz'
  sha1 '1df2fbaea768ab5390c83c2f6185670a429d0051'

  def install
    bin.install "rfcmarkup"
  end
end
