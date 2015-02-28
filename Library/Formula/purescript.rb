require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  homepage "http://www.purescript.org/"
  url "https://hackage.haskell.org/package/purescript-0.6.3/purescript-0.6.3.tar.gz"
  sha1 "0819a88f08f450a7e1b26aa0a42a440ba01053d0"

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
    install_cabal_package
  end

  test do
    (testpath/"t.purs").write "module Main where"
    system "psc", testpath/"t.purs"
  end
end
