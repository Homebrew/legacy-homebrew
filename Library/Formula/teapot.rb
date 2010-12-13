require 'formula'

class Teapot <Formula
  url 'http://www.moria.de/~michael/teapot/teapot-1.09.tar.gz'
  homepage 'http://www.moria.de/~michael/teapot/'
  md5 '21e1d1c1d04ba59af1fac6f49a4e2b1b'

  def install
    system "make"
    bin.install 'teapot'
  end
end
