require "language/haskell"

class Purescript < Formula
  include Language::Haskell::Cabal

  homepage "http://www.purescript.org"
  url "http://hackage.haskell.org/package/purescript-0.6.8/purescript-0.6.8.tar.gz"
  sha1 "70fd4d3109d61c34c8898a30d222c4b1ad8fd7a5"

  bottle do
    sha1 "b5628dbaabd07215c54979156b2d2f66fb6034c0" => :yosemite
    sha1 "0d082d33a31bae337188e0866180120a8b38c66d" => :mavericks
    sha1 "e9bbad2add5f0961926a0df8adbd8a3848781747" => :mountain_lion
  end

  depends_on "cabal-install" => :build
  depends_on "ghc"

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
