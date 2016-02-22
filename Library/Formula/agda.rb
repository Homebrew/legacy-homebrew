require "language/haskell"

class Agda < Formula
  include Language::Haskell::Cabal

  desc "Dependently typed functional programming language"
  homepage "http://wiki.portal.chalmers.se/agda/"

  stable do
    url "https://github.com/agda/agda/archive/2.4.2.5.tar.gz"
    sha256 "a357470e47751e5757922b05ab8d692a526b8ed50619fb3dab0735a9a0e94cd1"

    resource "stdlib" do
      url "https://github.com/agda/agda-stdlib.git",
          :tag => "v0.11",
          :revision => "8602c29a7627eb001344cf50e6b74f880fb6bf18"
    end

    # Remove when 2.5.1 is released
    # https://github.com/agda/agda/issues/1779
    # This is the last config that has
    #   - unordered-containers ==0.2.5.1
    #   - transformers-compat-0.4.0.4
    resource "cabal_config" do
      url "https://www.stackage.org/nightly-2016-02-08/cabal.config"
      sha256 "d4f4a0fcdfe486d0604d3e9810e8671793f4bb64d610bcd81fafa2aaa14c60c8"
    end
  end

  bottle do
    sha256 "499162feef2e0f8357743b4166a468cfa46b75145f44bc4684e7ad7ca3164f9f" => :el_capitan
    sha256 "9da031fabbbac72c22bcc6788d1a76d02be5947d496ee7d590bc735762e7c21c" => :yosemite
    sha256 "4a8b2ecdaec7b443cfac1b0e2336f2d849e1180919fff3f6682f70ae6a57c0f0" => :mavericks
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

  def install
    # Remove when 2.5.1 is released
    # https://github.com/agda/agda/issues/1779
    resource("cabal_config").stage(buildpath) if build.stable?

    # install Agda core
    install_cabal_package :using => ["alex", "happy", "cpphs"]

    if build.with? "stdlib"
      resource("stdlib").stage lib/"agda"

      # generate the standard library's bytecode
      cd lib/"agda" do
        cabal_sandbox :home => buildpath, :keep_lib => true do
          cabal_install "--only-dependencies"
          cabal_install
          system "GenerateEverything"
        end
      end

      # install the standard library's FFI bindings for the MAlonzo backend
      # in a dedicated GHC package database
      if build.with? "malonzo"
        db_path = lib/"agda"/"ffi"/"package.conf.d"

        mkdir db_path
        system "ghc-pkg", "--package-db=#{db_path}", "recache"

        cd lib/"agda"/"ffi" do
          cabal_sandbox :home => buildpath, :keep_lib => true do
            system "cabal", "--ignore-sandbox", "install", "--package-db=#{db_path}",
              "--prefix=#{lib}/agda/ffi"
          end
        end
      end

      # generate the standard library's documentation and vim highlighting files
      cd lib/"agda" do
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
        #{HOMEBREW_PREFIX}/lib/agda/src
      EOS

      if build.with? "malonzo"
        s += <<-EOS.undent

        To use the FFI bindings for the MAlonzo backend, give Agda the following option:
          --ghc-flag=-package-db=#{HOMEBREW_PREFIX}/lib/agda/ffi/package.conf.d
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
      system bin/"agda", "-i", testpath, "-i", lib/"agda"/"src",
        "--ghc-flag=-package-db=#{lib}/agda/ffi/package.conf.d",
        "-c", test_file_path
      assert_equal "Hello, world!", shell_output("#{testpath}/stdlib-test")
    end
  end
end
