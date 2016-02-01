require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.8.0.tar.gz"
  sha256 "fb5332191c9021e62222c6da8505aed02838276b988a5233dffc5e8f3114b167"

  bottle do
    sha256 "16049cc723f853a748ddec257ba2326d7a7aefdf3c8fc30052289ac3a1568242" => :el_capitan
    sha256 "a24c414bd02fd646d5c430a09e48ce8ed17eaa7f0b7ab68f21084a046d00062d" => :yosemite
    sha256 "64ab9e1da4c55d9a1170bfe5ce80c22ab6162bfd2bba34e8377b9cdc9216d237" => :mavericks
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
