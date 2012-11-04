require 'formula'

class CabalInstall < Formula
  homepage 'http://www.haskell.org/haskellwiki/Cabal-Install'
  url 'http://www.haskell.org/cabal/release/cabal-install-0.14.0/cabal-install-0.14.0.tar.gz'
  sha1 '614a683ec15a8d9b77e8d926c6906e8d00e3d401'

  depends_on 'ghc'

  def install
    ENV['PREFIX'] = "#{prefix}"
    ENV['VERBOSE'] = ''
    system "sh bootstrap.sh"

    (prefix+'etc/bash_completion.d').install 'bash-completion/cabal'
  end
end
