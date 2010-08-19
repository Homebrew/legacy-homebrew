require 'formula'

class Lolcode <Formula
  homepage 'http://www.icanhaslolcode.org/'
  head 'git://github.com/justinmeza/lolcode.git'

  def install
    system "make"
    bin.install 'lolcode'
  end
end
