require 'formula'

class Wgetpaste < Formula
  homepage 'http://wgetpaste.zlin.dk/'
  url 'http://wgetpaste.zlin.dk/wgetpaste-2.20.tar.bz2'
  sha1 'a50a5ecb236b4f7bbd4188e47a3b892b1dc90595'

  def install
    bin.install 'wgetpaste'
  end
end
