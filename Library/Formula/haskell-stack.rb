require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://www.stackage.org"
  url "https://github.com/commercialhaskell/stack/archive/v0.1.5.0.tar.gz"
  sha256 "2e32a0ac6a7e2a602eb039298925097141d00149119b2aa490a083b02a2002e2"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "0cbdf240354fd818d3a87d29433d8e6dc079d2a0d21d0b63c43e2c97532da994" => :yosemite
    sha256 "32fa5d0097021a06ebee64974307490501b67714d26c4ca518fa921a92974668" => :mavericks
    sha256 "6ff08a813b8c756f447c606ea059697827ba29160546343e72b0ad87102e208c" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pcre"

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
