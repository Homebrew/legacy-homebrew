require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  desc "Domain-specific language for specifying cryptographic algorithms"
  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "v2.2.6",
      :revision => "22fa2f0538f8c6c60f32735f54fe9877f56e1cba"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "68e7672e7481772a3fc758682d76f55480ea9d125b889c011340f9165ff0cf76" => :yosemite
    sha256 "d5f1fa017614729c6c849bda23d568689c17d782e1f2157254795c3486affe57" => :mavericks
    sha256 "eeae281e614864184053d9814c75ccf796dd79303f0281234bf4cda85cfbe996" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "z3"

  setup_ghc_compilers

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
