require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.7.0.tar.gz"
  sha256 "aea0fec66044ae2a3d05c88824ab9dc50d9744c5c7831c5ca749b1412fb156e7"

  bottle do
    sha256 "e0f8b7db0dee83488d17f22ba00df2e9c252ff4f6d7591cc6c2f42d063a04e97" => :el_capitan
    sha256 "462d6d468b1064a3d75a63126b5263fd5091417400a268f30909a85d96239613" => :yosemite
    sha256 "b1995100f87c03ba6cc4a272e13792ac421674b77b16b2479add947a5b19e22e" => :mavericks
    sha256 "19b4e283ff429735340b272038e4a2983b57171c6851863c37be1fc9a99df787" => :mountain_lion
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
