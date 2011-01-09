require 'formula'

class HsCabalInstall <Formula
  url 'http://hackage.haskell.org/packages/archive/cabal-install/0.8.2/cabal-install-0.8.2.tar.gz'
  homepage 'http://hackage.haskell.org/package/cabal-install'
  md5 '4abd0933dff361ff69ee9288a211e4e1'

  depends_on 'ghc'
  depends_on 'hs-http'
  depends_on 'hs-network'
  depends_on 'hs-zlib'

  def install
    system "runhaskell Setup.hs configure --prefix #{prefix} --libdir #{prefix}/lib/haskell"
    system 'runhaskell Setup.hs build'
    system 'runhaskell Setup.hs install'
  end
end
