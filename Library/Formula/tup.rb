require 'formula'

class Tup < Formula
  url 'git://github.com/gittup/tup.git', :tag => 'v0.4.1'
  homepage 'http://gittup.org/tup/'
  version '0.4.1'

  depends_on 'fuse4x'
  depends_on 'pkg-config'

  def install
    inreplace 'Tupfile', '`git describe`', version
    system "./bootstrap.sh"
    bin.install('tup')
    man1.install 'tup.1'
  end

  def test
    system "tup -v"
  end
end
