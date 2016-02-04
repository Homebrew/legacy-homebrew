require "language/haskell"

class Hledger < Formula
  include Language::Haskell::Cabal

  desc "Command-line accounting tool"
  homepage "http://hledger.org"
  url "https://hackage.haskell.org/package/hledger-0.27/hledger-0.27.tar.gz"
  sha256 "0aecdf586a46c24d6d67659157d1edbfc0d78afb50ea7cfbec1a01bf86b792b0"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    install_cabal_package :using => ["happy"]
  end

  test do
    system "#{bin}/hledger", "test"
  end
end
