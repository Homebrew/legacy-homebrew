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
    sha256 "9643af9999d726207637d934f8eab3c9a336a35436f12a4db7eb4f483ac98294" => :el_capitan
    sha256 "9974c88e44602ab06a725a52867e1315e99527095625bdb02a911c0d7f0f2d1b" => :yosemite
    sha256 "4b3c0e6576fee29f9db6e3f089d55854724c91d11112b43c1a3ca224385efaea" => :mavericks
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
