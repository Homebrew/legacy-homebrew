require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "v2.2.1",
      :revision => "300ed3cba993e49d0dbe34205d4f404524a3ffdd"
  sha256 "90d2cbe35db8b2a9fcd78eaa2c08ab0cd81641a30949ab855dde71d17429d3ee"
  head "https://github.com/GaloisInc/cryptol.git"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "cvc4"

  def install
    cabal_sandbox do
      system "make", "PREFIX=#{prefix}", "install"
    end
  end

  test do
    (testpath/"hello.icry").write <<-EOS.undent
      :prove \\(x : [8]) -> x == x
      :prove \\(x : [32]) -> x + zero == x
    EOS
    result = shell_output "#{bin}/cryptol -b #{(testpath/"hello.icry")}"
    expected = <<-EOS.undent
      Loading module Cryptol
      Q.E.D.
      Q.E.D.
    EOS
    assert_match expected, result
  end
end
