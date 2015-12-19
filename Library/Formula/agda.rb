require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"
  revision 2

  stable do
    url "https://github.com/agda/agda/archive/2.4.2.4.tar.gz"
    sha256 "0147f8a1395a69bee1e7a452682094e45c83126233f9864544b8a14f956ce8c3"

    # fix compilation of the included Emacs mode
    # merged upstream in https://github.com/agda/agda/pull/1700
    patch :DATA

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git",
          :tag => "v0.11",
          :revision => "8602c29a7627eb001344cf50e6b74f880fb6bf18"
    end
  end

  bottle do
    revision 1
    sha256 "72926be89f32a171d46e92aeefcca5005f9c0078689d9d63427757b1b5651bfb" => :el_capitan
    sha256 "2822c9f9ce79c0354da58ba604190c6eb8bebf64f0be4925b7cd2d9f1bb1f950" => :yosemite
    sha256 "aee69ac2b9cdf715f39defba8b81d6572dc02e5edb21417781a39932fc132356" => :mavericks
  end

  head do
    url "https://github.com/agda/agda.git"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git"
    end
  end

  option "without-stdlib", "Don't install the Agda standard library"
  option "without-malonzo", "Disable the MAlonzo backend"

  if build.with? "malonzo"
    depends_on "ghc"
  else
    depends_on "ghc" => :build
  end
  depends_on "cabal-install" => :build

  depends_on "gmp"
  depends_on :emacs => ["21.1", :recommended]

  setup_ghc_compilers

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

      # generate the standard library's bytecode
      cd prefix/"agda-stdlib" do
        cabal_sandbox do
          cabal_install "--only-dependencies"
          cabal_install
          system "GenerateEverything"
        end
        rm_rf [".cabal", "dist"]
      end

      # install the standard library's FFI bindings for the MAlonzo backend
      # in a dedicated GHC package database
      if build.with? "malonzo"
        db_path = prefix/"agda-stdlib"/"ffi"/"package.conf.d"

        mkdir db_path
        system "ghc-pkg", "--package-db=#{db_path}", "recache"

        cd prefix/"agda-stdlib"/"ffi" do
          cabal_sandbox do
            system "cabal", "--ignore-sandbox", "install", "--package-db=#{db_path}",
              "--prefix=#{prefix/"agda-stdlib"/"ffi"}"
          end
          rm_rf [".cabal", "dist"]
        end
      end

      # generate the standard library's documentation and vim highlighting files
      cd prefix/"agda-stdlib" do
        system bin/"agda", "-i", ".", "-i", "src", "--html", "--vim", "README.agda"
      end
    end

    # compile the included Emacs mode
    if build.with? "emacs"
      system bin/"agda-mode", "compile"
      elisp.install_symlink Dir["#{share}/*/Agda-#{version}/emacs-mode/*"]
    end
  end

  def caveats
    s = ""

    if build.with? "stdlib"
      s += <<-EOS.undent
      To use the Agda standard library, point Agda to the following include dir:
        #{prefix/"agda-stdlib"/"src"}
      EOS

      if build.with? "malonzo"
        s += <<-EOS.undent

        To use the FFI bindings for the MAlonzo backend, give Agda the following option:
          --ghc-flag=-package-db=#{prefix/"agda-stdlib"/"ffi"/"package.conf.d"}
        EOS
      end
    end

    s
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
    if build.with? "malonzo"
      system bin/"agda", "-c", "--no-main", "--safe", test_file_path
    end
    system bin/"agda", "--js", "--safe", test_file_path

    # typecheck, compile, and run a program that uses the standard library
    if build.with?("stdlib") && build.with?("malonzo")
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
        "--ghc-flag=-package-db=#{prefix/"agda-stdlib"/"ffi"/"package.conf.d"}",
        "-c", test_file_path
      assert_equal "Hello, world!", shell_output("#{testpath/"stdlib-test"}")
    end
  end
end

__END__
diff --git a/src/data/emacs-mode/agda2-mode.el b/src/data/emacs-mode/agda2-mode.el
index 04604ee..f6b3122 100644
--- a/src/data/emacs-mode/agda2-mode.el
+++ b/src/data/emacs-mode/agda2-mode.el
@@ -20,6 +20,7 @@ Note that the same version of the Agda executable must be used.")
 (require 'time-date)
 (require 'eri)
 (require 'annotation)
+(require 'fontset)
 (require 'agda-input)
 (require 'agda2)
 (require 'agda2-highlight)
