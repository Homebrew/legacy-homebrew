require 'formula'

class CabalInstall <Formula
  url 'http://www.haskell.org/cabal/release/cabal-install-0.8.2/cabal-install-0.8.2.tar.gz'
  homepage 'http://www.haskell.org/cabal/'
  md5 '4abd0933dff361ff69ee9288a211e4e1'

  depends_on 'ghc'

  def install
    ENV['PREFIX'] = prefix
    system "sh", "./bootstrap.sh", "--user"
  end
end
