require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "v2.2.4",
      :revision => "ebaa98699bfc704c5ac5a100e2829e68f3a11d9b"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "9242d48cf126dd4ae9eb8f3d843e022d86cc89df55fb98e3c5ee4e87805f9be5" => :yosemite
    sha256 "9da91e105a5e3ec090e420d56026e0c56fdf1ba37008c1d4b845652f68d66aff" => :mavericks
    sha256 "5c5bf1a0e83cc800d9b32c1d976a1e96ce12b05c0bf6106e9e11ccab11b3b757" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "cvc4"

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
