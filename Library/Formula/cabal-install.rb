require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  version '0.10.2'
  url 'http://hackage.haskell.org/packages/archive/cabal-install/0.10.2/cabal-install-0.10.2.tar.gz'
  md5 'bc906ef0bed79cbb33fdb36b73514281'

  depends_on 'ghc'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "sh bootstrap.sh"
  end

  def caveats; <<-EOS.undent
    Using cabal-install + GHC is the way to go for people who do not want the
    haskell-platform. Please choose either the platform or this, but not both.
    
    Don't forget running "cabal update" before you try to install new hackages!
    EOS
  end
end
