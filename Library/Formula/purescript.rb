require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.2.tar.gz"
  sha256 "7155da1869f4483be0a3745ad8b7cd1d93c7fa264d17362b8dfc246d93b4c483"

  bottle do
    sha256 "b18991a70fb90babdd6860bbc638afd0e57328cb4b58702287cbc6673d0d60b7" => :el_capitan
    sha256 "ca0da69c04c715b48b734ad0158c26da38a608a1db2d6186dadc7673b43d4c26" => :yosemite
    sha256 "dc2e83104a0454951fa0890079225038934fd0775ef9f2e483c15e55636c1e74" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["alex", "happy"]
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
