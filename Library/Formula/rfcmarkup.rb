require 'formula'

class Rfcmarkup <Formula
  url 'http://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.89.tgz'
  homepage 'http://tools.ietf.org/tools/rfcmarkup/'
  md5 '092b483eba45facf28f78adfa15d42a0'

  def install
    inreplace "rfcmarkup", "/usr/local/bin/python", "/usr/bin/env python"
    bin.install "rfcmarkup"
    prefix.install 'todo'
  end
end
