require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.0.2/texmath-0.8.0.2.tar.gz"
  sha256 "47b9c3fdceed63c5d63987db7e511a38ea8ddf8591786ef56efea734a3c31f86"

  bottle do
    sha256 "2b95621346d6c76d000f6830efc0104eb6c6cacc4b256b30418e4d7a67290fb0" => :yosemite
    sha256 "a24734d011de31db7494f97bcb019116053867ca630e1c13a9063bea30af38e0" => :mavericks
    sha256 "8a72fa59caf3ae61a99202361bec3523adab83d4e2b909d0e7de16f4a84256a1" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}", "-fexecutable"
    end
    cabal_clean_lib
  end

  test do
    assert_match "<mn>2</mn>", pipe_output("texmath", "a^2 + b^2 = c^2")
  end
end
