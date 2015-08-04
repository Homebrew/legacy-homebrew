require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"
  url "https://hackage.haskell.org/package/Agda-2.4.2.3/Agda-2.4.2.3.tar.gz"
  mirror "https://github.com/agda/agda/archive/2.4.2.3.tar.gz"
  sha256 "bc6def45e32498f51863d67acfbe048c039d630c6a36761ed27e99a5f68d7b27"
  revision 2

  bottle do
    sha256 "b5dfadfde1b45ca3d70f2ac812e98a6d72caf1d840d4cb9c4eee95e81d74ff0b" => :yosemite
    sha256 "4513aecea2fbf5d1a682e04e4cccfd795d48836bcf1b16f79c24fa3bd6482854" => :mavericks
    sha256 "d0e17808ee896cdedc499b010b67961dc3db3c430c501faef16c4b4482238447" => :mountain_lion
  end

  head "https://github.com/agda/agda.git", :branch => "master"

  option "without-stdlib", "Don't install the Agda standard library"
  option "with-malonzo-ffi",
    "Include the MAlonzo backend's FFI (depends on the standard library)"

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build

  depends_on "gmp"
  depends_on "emacs" => :optional

  setup_ghc_compilers

  head do
    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git", :branch => "master"
    end
  end

  resource "stdlib" do
    url "https://github.com/agda/agda-stdlib.git", :branch => "2.4.2.4"
  end

  def install
    # install Agda core
    cabal_sandbox do
      cabal_install_tools "alex", "happy", "cpphs"
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
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
    if build.with?("stdlib") && build.with?("malonzo-ffi")
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
