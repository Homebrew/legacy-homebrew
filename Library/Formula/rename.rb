require 'formula'

class Rename < Formula
  homepage 'http://plasmasturm.org/code/rename'
  url 'https://github.com/ap/rename/zipball/v1.100'
  sha1 'fad32374f16802fa6bb94c41cdb9f50d63bfafcb'

  def install
    system 'pod2man', 'rename', 'rename.1'
    bin.install 'rename'
    man1.install 'rename.1'
  end
end
