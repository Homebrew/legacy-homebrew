require 'formula'

class Shellcheck < Formula
  homepage 'https://github.com/koalaman/shellcheck#readme'
  url      'https://github.com/koalaman/shellcheck/archive/v0.1.0.tar.gz'
  sha1     '1e046151f266f3d5c7acfdc51f1f38a7d07bd9c9'
  head     'https://github.com/koalaman/shellcheck.git'

  depends_on 'ghc' => :build
  depends_on :cabal

  depends_on 'parsec' => :haskell
  depends_on 'regex-posix' => :haskell
  depends_on 'regex-compat' => :haskell

  def install
    mkdir_p bin
    system 'ghc', '-O9', '--make', 'shellcheck', '-o', bin/'shellcheck'
  end

  test do
    system "#{bin}/shellcheck 2>&1 | grep 'static analysis tool'"
  end
end
