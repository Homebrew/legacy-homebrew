require "language/haskell"

class Te < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jetaggart/te"
  url "https://github.com/jetaggart/te/archive/v0.1.2.tar.gz"
  sha1 "43e744107ef9c8bc8f0489e57bbc2d8beded855f"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "te", "help"
  end
end
