require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://github.com/commercialhaskell/stack"
  url "https://hackage.haskell.org/package/stack-0.1.8.0/stack-0.1.8.0.tar.gz"
  sha256 "89bca19a39f3148daa55dd51bcee28c9f8aa362732c915dd25a85c7a7c664338"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "fdc76cef3456f5c68422153ed9fe07a3c685d09ded030af960ac9799cbe38219" => :el_capitan
    sha256 "b54a27624a1bf02b457e8b6daf650a227cdb3131dcd4b1762a14bcbd1f7bbcf2" => :yosemite
    sha256 "ea091e3806234f3d4d1c0769db788d0063affe2545023d630c3c329639d221e6" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "#{bin}/stack", "new", "test"
  end
end
