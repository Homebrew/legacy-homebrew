require "language/haskell"

class Texmath < Formula
  include Language::Haskell::Cabal

  desc "Haskell library for converting LaTeX math to MathML"
  homepage "http://johnmacfarlane.net/texmath.html"
  url "https://hackage.haskell.org/package/texmath-0.8.0.2/texmath-0.8.0.2.tar.gz"
  sha256 "47b9c3fdceed63c5d63987db7e511a38ea8ddf8591786ef56efea734a3c31f86"

  revision 1

  bottle do
    sha256 "ba657b85f95ff38251a9a60146702dc15b3622649881d13075e70cac4213e307" => :yosemite
    sha256 "33deabb7df69aec183d03eb169f99be6ba65a13f518c5be6528bd624b9015904" => :mavericks
    sha256 "70545b7f939bb5156cccf4537f5364c1ec00605099ab2d9fc653da66cbbbcbc5" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  setup_ghc_compilers

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
