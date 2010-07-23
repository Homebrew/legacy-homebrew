require 'formula'

class HsZlib <Formula
  url 'http://hackage.haskell.org/packages/archive/zlib/0.5.2.0/zlib-0.5.2.0.tar.gz'
  homepage 'http://hackage.haskell.org/package/zlib'
  md5 '19859e241dc18ef1501a5d44d8523507'

  depends_on 'ghc'

  def install
    system "runhaskell Setup.hs configure --prefix #{prefix} --libdir #{prefix}/lib/haskell"
    system "runhaskell Setup.hs build"
    system "runhaskell Setup.hs install"
  end
end
