require 'formula'

class Rfcmarkup <Formula
  url 'http://tools.ietf.org/tools/rfcmarkup/rfcmarkup-1.90.tgz'
  homepage 'http://tools.ietf.org/tools/rfcmarkup/'
  md5 'bcab3d383c29b438df47e1a1d104e9db'

  def install
    inreplace "rfcmarkup", "/usr/local/bin/python", "/usr/bin/env python"
    bin.install "rfcmarkup"
    prefix.install 'todo'
  end
end
