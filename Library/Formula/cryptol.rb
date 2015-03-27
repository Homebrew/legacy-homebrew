require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "v2.2.1",
      :revision => "300ed3cba993e49d0dbe34205d4f404524a3ffdd"
  sha256 "90d2cbe35db8b2a9fcd78eaa2c08ab0cd81641a30949ab855dde71d17429d3ee"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "6579d3c4aaad5c7c5a45b7185454572c32fdc03feede6a18376f5cca142b0adc" => :yosemite
    sha256 "fc2210e5169622d485648e1e187cdd51d1d8dae1a393b2a4ce765ae23c0fd7ba" => :mavericks
    sha256 "393b778484108ce0081612851bf7b7d7ad03f4f751a051be7997b4281dd6059e" => :mountain_lion
  end

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
