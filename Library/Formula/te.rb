require "language/haskell"

class Te < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jetaggart/te"
  url "https://github.com/jetaggart/te/archive/v0.1.1.tar.gz"
  sha1 "a6e4e9c7872844d84f300234d54897f0fa8f22ef"

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
    system "te", "help", ">", "output.txt"
    assert (Pathname.pwd/"output.txt").read.include? "Valid commands are"
  end
end
