require "language/haskell"

class HaskellStack < Formula
  include Language::Haskell::Cabal

  desc "The Haskell Tool Stack"
  homepage "https://haskellstack.org"
  url "https://hackage.haskell.org/package/stack-0.1.10.0/stack-0.1.10.0.tar.gz"
  sha256 "9b730c2b4b7bb87fc70ccbf0bab0e2fe6f0775644b36972b4dea9088cbcab979"

  head "https://github.com/commercialhaskell/stack.git"

  bottle do
    sha256 "459140f201218d7e5e9fac9f48e5b9b26ba040bba49e4093e8e3687c506f7e73" => :el_capitan
    sha256 "7c45454f2f0472254bf2405f045541696c02ce907f0a1f9ef0076a31487499b3" => :yosemite
    sha256 "a48a8e370dd5efab8a392be57fcac827bfc62312a45793feba6630b1af387a79" => :mavericks
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
