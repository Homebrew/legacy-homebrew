require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "2.3.0",
      :revision => "eb51fab238797dfc10274fd60c68acd4bdf53820"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "58595e61bb8681a1871668217a3462db76a84f7a437b58014fa1589ba3863b06" => :el_capitan
    sha256 "2c3f5331ff9c08ee17307c48dabd23bc7768388901789973e0054a4890981bb6" => :yosemite
    sha256 "5af2fca89194f8b0be00311d96990a7e99ed725983631a08777ad28d2163020f" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3"

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
