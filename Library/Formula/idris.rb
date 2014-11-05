require "formula"
require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.15.1.tar.gz"
  sha1 "064608a43f8544b2c15cefde9e6a22a83ebea904"
  head "https://github.com/idris-lang/Idris-dev.git"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    install_cabal_package
  end

  test do
    (testpath/"hello.idr").write <<-EOS.undent
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS
    shell_output "#{bin/"idris"} #{testpath/"hello.idr"} -o #{testpath/"hello"}"
    result = shell_output "#{testpath/"hello"}"
    assert_match /Hello, Homebrew!/, result
  end
end
