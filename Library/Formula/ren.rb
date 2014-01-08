require 'formula'

class Ren < Formula
  homepage 'http://pdb.finkproject.org/pdb/package.php/ren'
  url 'http://www.ibiblio.org/pub/Linux/utils/file/ren-1.0.tar.gz'
  sha1 '3f21fc85f5996c85cc3b3dd09ceb9cb4d90f36a9'

  def install
    system "make"
    bin.install "ren"
    man1.install "ren.1"
  end
end
