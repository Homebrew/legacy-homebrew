require 'formula'

class Pymetar <Formula
  url 'http://schwarzvogel.de/pkgs/pymetar-0.17.tar.gz'
  homepage 'http://schwarzvogel.de/software-pymetar.shtml'
  md5 'c02450ee386da5788b37e0114150c59a'

  depends_on 'pymetar' => :python

  def install
    bin.install ['bin/pymetar']
    man1.install ['pymetar.1']
  end
end
