require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://www.stackage.org"
  url "https://github.com/commercialhaskell/stack/archive/v0.1.2.0.tar.gz"
  sha256 "20ff0a36f773c2993e00c6f1bffaa33e881906d20f66cde0d557133842fc464c"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "1def37b5df9d9423081b8d5a8fa3d5958fcecfa664b75695d6fdde2fb5877e4a" => :yosemite
    sha256 "4c106bef7f02774b35ddae28f409b5b51d0630a77e0436befb65ac7430277001" => :mavericks
    sha256 "86d6ea580bbfa3b645ea6a3558cfde24979b8d87fd6eb211ffc82415d721fcaa" => :mountain_lion
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
    system "#{bin}/stack", "new"
  end
end
