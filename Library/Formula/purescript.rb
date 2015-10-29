require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  desc "Strongly typed programming language that compiles to JavaScript"
  homepage "http://www.purescript.org"
  url "https://github.com/purescript/purescript/archive/v0.7.5.tar.gz"
  sha256 "127bbb12a60455c4fad6a80b3e58afc8e45b5435e3f9432d001fa12a2657ca44"

  bottle do
    sha256 "1f83b0ed875ce1f2f4f76fb17fd9763a62536f956e92b1508c3270112fd39c69" => :el_capitan
    sha256 "0736565aca050ea83249fca79e9e3d31e2fdc72dc8671911686374c2d05eda6b" => :yosemite
    sha256 "560321f411dd302e9fa819e411e49d571f7c88e5eb324b1b973144d1878c2d6c" => :mavericks
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
