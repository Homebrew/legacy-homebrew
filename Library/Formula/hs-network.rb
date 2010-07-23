require 'formula'

class HsNetwork <Formula
  url 'http://hackage.haskell.org/packages/archive/network/2.2.1.7/network-2.2.1.7.tar.gz'
  homepage 'http://hackage.haskell.org/package/network'
  md5 '566cfeef09ff4d2e52110ec4a9a9879b'

  depends_on 'ghc'
  depends_on 'hs-parsec'

  def install
    system "runhaskell Setup.hs configure --prefix #{prefix} --libdir #{prefix}/lib/haskell"
    system "runhaskell Setup.hs build"
    system "runhaskell Setup.hs install"
  end
end
