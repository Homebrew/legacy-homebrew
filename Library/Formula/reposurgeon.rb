require 'formula'

class Reposurgeon <Formula
  url 'http://www.catb.org/esr/reposurgeon/reposurgeon-0.5.tar.gz'
  homepage 'http://www.catb.org/esr/reposurgeon/'
  md5 '39ef99f482418617264df365bcfe28e6'

  def install
    bin.install "reposurgeon"
    man1.install "reposurgeon.1"
  end
end
