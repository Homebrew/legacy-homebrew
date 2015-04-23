require "language/haskell"

class HighlightingKate < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/highlighting-kate"
  url "https://github.com/jgm/highlighting-kate/archive/0.5.15.tar.gz"
  sha256 "fc4b22e3709da6a15f5fac5feda31bd08807f8b6e63f45c8dbd50ad489d750c9"

  head "https://github.com/jgm/highlighting-kate.git"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      system "make", "prep"
      cabal_install "--prefix=#{prefix}", "-fsplitBase", "-fexecutable"
    end
    cabal_clean_lib
  end

  test do
    system "highlighting-kate", "-s", "json", prefix/"INSTALL_RECEIPT.json"
  end
end
