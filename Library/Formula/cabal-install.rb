require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://www.haskell.org/cabal/release/cabal-install-0.10.2/cabal-install-0.10.2.tar.gz'
  md5 'bc906ef0bed79cbb33fdb36b73514281'

  depends_on 'ghc'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "sh bootstrap.sh"
  end
end
