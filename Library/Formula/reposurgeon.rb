require 'formula'

class Reposurgeon < Formula
  url 'http://www.catb.org/esr/reposurgeon/reposurgeon-1.9.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  sha1 'd0a5b297e7968efdb721970ca72f3ac2f682ad5d'

  def install
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
  end
end
