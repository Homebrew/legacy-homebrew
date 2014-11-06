require "formula"
require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.15.1.tar.gz"
  sha1 "064608a43f8544b2c15cefde9e6a22a83ebea904"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha1 "1fd1c7c3f223512d2869e8790c4e5afb0f196409" => :yosemite
    sha1 "b8a7ffc5ed4429665658e54cefe400bacbc26c53" => :mavericks
    sha1 "6dc50e41562eef4d18987f6f673b8a77f22a5512" => :mountain_lion
  end

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
    shell_output "#{bin}/idris #{testpath}/hello.idr -o #{testpath}/hello"
    result = shell_output "#{testpath}/hello"
    assert_match /Hello, Homebrew!/, result
  end
end
