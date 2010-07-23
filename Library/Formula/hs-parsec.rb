require 'formula'

class HsParsec <Formula
  url 'http://hackage.haskell.org/packages/archive/parsec/3.1.0/parsec-3.1.0.tar.gz'
  homepage 'http://hackage.haskell.org/package/parsec'
  md5 '310bf233dcf8ec678c427b1198700b53'

  depends_on 'ghc'
  depends_on 'hs-mtl'

  def install
    system "runhaskell Setup.hs configure --prefix #{prefix} --libdir #{prefix}/lib/haskell"
    system "runhaskell Setup.hs build"
    system "runhaskell Setup.hs install"
  end
end
