require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://www.stackage.org"
  url "https://github.com/commercialhaskell/stack/archive/v0.1.3.1.tar.gz"
  sha256 "3e6a575a3f5206af345912c4deba9552dfb156391357cec4eb1c2a9028ba4c51"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "cb28bda6f3aae15015f5fcf58b1ef36655a609542da709fb51ce8138440fa341" => :yosemite
    sha256 "ca459d7260b5092be38c2a395d5dd5f248b6f9020ab2f3c5032a29ad7754ebb5" => :mavericks
    sha256 "d538c8a32841c5f6203297c8b8b059f2e98a01ba82e9c353a24194952f19d203" => :mountain_lion
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
