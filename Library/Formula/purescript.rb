require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.7.5.3.tar.gz"
  sha256 "d1198dbc9396ee4b1f1b7aa9b83fc75449ac369e66a58b9d4367bdd025e90513"

  bottle do
    sha256 "5af33fb77c4859cd85d2bed08c72dc1ae79630b3d7390b909114fc323a92f60a" => :el_capitan
    sha256 "e8a105d34734df4986f39894b5e238a7f9290790efbf2d1a1df68bc36db28d07" => :yosemite
    sha256 "921e90b74645fb577d848028e31b92d838048a3a1b0a9df2dbaa31516ef5b7fa" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy"
      install_cabal_package
    end
    cabal_clean_lib
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<-EOS.undent
      module Test where

      main :: Int
      main = 1
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
