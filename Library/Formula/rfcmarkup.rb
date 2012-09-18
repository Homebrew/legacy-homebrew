require 'formula'

class Rfcmarkup < Formula
  url 'http://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.90.tgz'
  homepage 'http://tools.ietf.org/tools/rfcmarkup/'
  sha1 '221c4d18b593d286e34ecfcabd7348e0c443c588'

  def install
    inreplace "rfcmarkup", "/usr/local/bin/python", "/usr/bin/env python"
    bin.install "rfcmarkup"
    prefix.install 'todo'
  end
end
