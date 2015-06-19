require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.6.9.5.tar.gz"
  sha256 "b7d24ce85c65a9d2adb178d2e9b628f8d4f5a33103c3da6f3312c63a1048ff80"

  bottle do
    sha256 "1f7e753da5fee42ed983254d5c8914e9c5cca3f876d219ca538726ae76aee68d" => :yosemite
    sha256 "df653749f0b80a3f406d2e23b870775e651a5f264701d879386dbd5fe86083cc" => :mavericks
    sha256 "dbab26a1e995dd5b64fed38bd9d287c2d33e519cedc5165ecdd2780429df82dc" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    install_cabal_package
  end

  test do
    test_module_path = testpath/"Test.purs"
    test_target_path = testpath/"test-module.js"
    test_module_path.write <<-EOS.undent
      module Test where
      import Control.Monad.Eff
      main :: forall e. Eff e Unit
      main = return unit
    EOS
    system bin/"psc", test_module_path, "-o", test_target_path
    assert File.exist?(test_target_path)
  end
end
