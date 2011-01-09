require 'formula'

class HsHttp <Formula
  url 'http://hackage.haskell.org/packages/archive/HTTP/4000.0.9/HTTP-4000.0.9.tar.gz'
  homepage 'http://hackage.haskell.org/package/HTTP'
  md5 'bbd005935537ed8883bfefb624e8bf3c'

  depends_on 'ghc'
  depends_on 'hs-network'
  depends_on 'hs-parsec'
  depends_on 'hs-mtl'

  def install
    system "runhaskell Setup.lhs configure --prefix #{prefix} --libdir #{prefix}/lib/haskell"
    system "runhaskell Setup.lhs build"
    system "runhaskell Setup.lhs install"
  end
end
