require 'formula'

class Reposurgeon <Formula
  url 'http://www.catb.org/esr/reposurgeon/reposurgeon-0.2.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  md5 '8151b9bc7d285b166b073056ada85e28'

  def install
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
  end
end
