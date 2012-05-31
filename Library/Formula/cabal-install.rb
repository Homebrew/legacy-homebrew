require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://www.haskell.org/cabal/release/cabal-install-0.14.0/cabal-install-0.14.0.tar.gz'
  md5 '638514bd1a5792d75866481852148ae5'

  depends_on 'ghc'

  def install
    ENV['PREFIX'] = "#{prefix}"
    system "sh bootstrap.sh"

    (prefix+'etc/bash_completion.d').install 'bash-completion/cabal'
  end
end
