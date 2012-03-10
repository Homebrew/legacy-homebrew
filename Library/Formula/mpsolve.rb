require 'formula'

class Mpsolve < Formula
  url 'http://www.dm.unipi.it/cluster-pages/mpsolve/mpsolve.tgz'
  homepage 'http://www.dm.unipi.it/cluster-pages/mpsolve/index.htm'
  md5 '4ef1b82066db972068f88f36382cb12f'
  version '2.2'

  depends_on 'gmp'

  def install
    system 'make'
    bin.install 'unisolve'
  end
end
