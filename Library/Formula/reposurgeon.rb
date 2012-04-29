require 'formula'

class Reposurgeon < Formula
  url 'http://www.catb.org/esr/reposurgeon/reposurgeon-1.9.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  md5 '5ebedd5f69e3e5b42aada02b237e724c'

  def install
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
  end
end
