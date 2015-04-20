require 'formula'

class Redsocks < Formula
  homepage 'http://darkk.net.ru/redsocks'
  url 'https://github.com/darkk/redsocks/archive/release-0.4.tar.gz'
  sha1 '5bc432652b9776c3ee04a3ef58fc9adef8190901'

  depends_on 'libevent'

  def install
    system 'make'
    bin.install 'redsocks'
  end
end
