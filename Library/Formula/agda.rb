require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  homepage "http://wiki.portal.chalmers.se/agda/"
  url "http://hackage.haskell.org/package/Agda-2.4.2.2/Agda-2.4.2.2.tar.gz"
  sha1 "fbdf7df3d5a036e683210ac7ccf4f8ec0c9fea05"
  revision 1

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

  option "without-epic-backend", "Exclude the Epic compiler backend"
  option "without-stdlib", "Don't install the Agda standard library"
  option "with-malonzo-ffi",
    "Include the MAlonzo backend's FFI (depends on the standard library)"

  depends_on "cabal-install" => :build
  depends_on "ghc"
  depends_on "gmp"
  depends_on "bdw-gc" if build.with? "epic-backend"
  depends_on "emacs" => :optional

  head do
    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", :branch => "master"
    end
  end
  resource "stdlib" do
    url "https://github.com/agda/agda-stdlib/archive/v0.9.tar.gz"
    sha1 "f39d5685ab2dc47758c87d9068047fce6b4b99a1"
  end

  def install
    if build.with? "epic-backend"
      epic_flag = "-fepic"
    else
      epic_flag = "-f-epic"
    end

    # install Agda core
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "cpphs"
      if build.with? "epic-backend"
        cabal_install "--prefix=#{prefix}", "epic"
      end
      cabal_install "--only-dependencies", epic_flag
      cabal_install "--prefix=#{prefix}", epic_flag
    end
    cabal_clean_lib

    if build.with? "stdlib"
      resource("stdlib").stage prefix/"agda-stdlib"

      # install the standard library's helper tools
      cd prefix/"agda-stdlib" do
        cabal_sandbox do
          cabal_install "--only-dependencies"
          cabal_install "--prefix=#{prefix/"agda-stdlib"}"
          system prefix/"agda-stdlib"/"bin"/"GenerateEverything"
        end
        cabal_clean_lib
      end

      # install the standard library's FFI bindings for the MAlonzo backend
      if build.with? "malonzo-ffi"
        cd prefix/"agda-stdlib"/"ffi" do
          cabal_install "--user"
        end
      end

      # generate the standard library's documentation and vim highlighting files
      cd prefix/"agda-stdlib" do
        system bin/"agda", "-i", ".", "-i", "src", "--html", "--vim", "README.agda"
      end
    end

    # byte-compile and install Agda's included emacs mode
    if build.with? "emacs"
      system bin/"agda-mode", "setup"
      system bin/"agda-mode", "compile"
    end
  end

  test do
    # run Agda's built-in test suite
    system bin/"agda", "--test"

    # typecheck and compile a simple module
    test_file_path = testpath/"simple-test.agda"
    test_file_path.write <<-EOS.undent
      {-# OPTIONS --without-K #-}
      module simple-test where
      open import Agda.Primitive
      infixr 6 _::_
      data List {i} (A : Set i) : Set i where
        [] : List A
        _::_ : A -> List A -> List A
      snoc : forall {i} {A : Set i} -> List A -> A -> List A
      snoc [] x = x :: []
      snoc (x :: xs) y = x :: (snoc xs y)
    EOS
    system bin/"agda", "-c", "--no-main", "--safe", test_file_path
    system bin/"agda", "--js", "--safe", test_file_path

    # typecheck, compile, and run a program that uses the standard library
    if build.with? "stdlib" and build.with? "malonzo-ffi"
      test_file_path = testpath/"stdlib-test.agda"
      test_file_path.write <<-EOS.undent
        module stdlib-test where
        open import Data.String
        open import Function
        open import IO
        main : _
        main = run $ putStr "Hello, world!"
      EOS
      system bin/"agda", "-i", testpath, "-i", prefix/"agda-stdlib"/"src",
        "-c", test_file_path
      assert_equal `testpath/"stdlib-test"`, "Hello, world!"
    end
  end
end
