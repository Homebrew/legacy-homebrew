class Stack < Formula
  desc "The Haskell Tool Stack"
  homepage "https://www.stackage.org"
  url "https://github.com/commercialhaskell/stack/archive/v0.1.2.0.tar.gz"
  sha256 "20ff0a36f773c2993e00c6f1bffaa33e881906d20f66cde0d557133842fc464c"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    system "cabal", "sandbox", "init"
    system "cabal", "update"
    system "cabal", "install", "--only-dependencies"
    system "cabal", "build"
    system "strip", "dist/build/stack/stack"
    bin.install "dist/build/stack/stack" => "stack"
  end

  test do
    system "#{bin}/stack", "new"
    system "#{bin}/stack", "setup"
    system "#{bin}/stack", "build"
  end
end
