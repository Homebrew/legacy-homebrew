require "language/haskell"

class Cryptol < Formula
  include Language::Haskell::Cabal

  homepage "http://www.cryptol.net/"
  url "https://github.com/GaloisInc/cryptol.git",
      :tag => "v2.2.2",
      :revision => "6ecd07da73c5ceadd211c5ef7c371a1b2facc29b"
  head "https://github.com/GaloisInc/cryptol.git"

  bottle do
    sha256 "9484b0bd7ee276b87e5c6f097079346495896eb972be09643b3de9f52981664f" => :yosemite
    sha256 "8ac78ea69c34dc0f8677288d085a4efe5558bd4c94095b81afd8578cdc007621" => :mavericks
    sha256 "280b21bd7084c3714f157988a799303d2aaeb51419123af7a08c631d4bec4e0a" => :mountain_lion
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
