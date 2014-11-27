require "formula"
require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  homepage "http://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.6.1.2/purescript-0.6.1.2.tar.gz"
  sha1 "645d9d11295e065d5a75cadf9a5eb08f2e3b90cb"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  fails_with :clang do
    cause <<-EOS
      GHC with clang fails to compile text-1.2.0.0. See also:

       - http://git.io/L5a_JA
       - https://ghc.haskell.org/trac/ghc/ticket/9711
    EOS
  end

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    (testpath/"t.purs").write "module Main where"
    system "psc", testpath/"t.purs"
  end
end
