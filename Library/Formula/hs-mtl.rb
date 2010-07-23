require 'formula'

class HsMtl <Formula
  url 'http://hackage.haskell.org/packages/archive/mtl/1.1.0.2/mtl-1.1.0.2.tar.gz'
  homepage 'http://hackage.haskell.org/package/mtl'
  md5 '1e933bb7abb38b7bb423929ba37219db'

  depends_on 'ghc'

  def install
    system "runhaskell Setup.hs configure --prefix #{prefix} --libdir #{prefix}/lib/haskell"
    system "runhaskell Setup.hs build"
    system "runhaskell Setup.hs install"
  end
end
