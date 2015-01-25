require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  homepage "http://wiki.portal.chalmers.se/agda/"
  url "http://hackage.haskell.org/package/Agda-2.4.2.2/Agda-2.4.2.2.tar.gz"
  sha1 "fbdf7df3d5a036e683210ac7ccf4f8ec0c9fea05"

  bottle do
    sha1 "d0827796e1d0ac2ba33ef73c8bec7f99ee95b02a" => :yosemite
    sha1 "7e49026d601135596b830b4a6b7032e463b1a51c" => :mavericks
    sha1 "0db7eb99ae43f17dc0509dbbf48341c20c534ef4" => :mountain_lion
  end

  devel do
    url "https://github.com/agda/agda.git", :branch => "maint-2.4.2"
    version "2.4.2.3-beta"
  end

  head "https://github.com/agda/agda.git", :branch => "master"

  option "without-epic-backend", "Exclude the 'epic' compiler backend"

  depends_on "cabal-install" => :build
  depends_on "ghc"
  depends_on "gmp"
  depends_on "bdw-gc" if build.with? "epic-backend"

  def install
    if build.with? "epic-backend"
      epic_flag = "-fepic"
    else
      epic_flag = "-f-epic"
    end
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "cpphs"
      cabal_install "--only-dependencies", epic_flag
      cabal_install "--prefix=#{prefix}", epic_flag
    end
    cabal_clean_lib
  end

  test do
    # run Agda's built-in test suite
    system bin/"agda", "--test"

    # typecheck and compile a simple module
    path = testpath/"test.agda"
    path.write <<-EOS.undent
      module test where
      open import Agda.Primitive
      infixr 6 _::_
      data List {i} (A : Set i) : Set i where
        [] : List A
        _::_ : A -> List A -> List A
      snoc : forall {i} {A : Set i} -> List A -> A -> List A
      snoc [] x = x :: []
      snoc (x :: xs) y = x :: (snoc xs y)
    EOS
    system bin/"agda", "-c", "--no-main", "--safe", "--without-K", path
  end
end
