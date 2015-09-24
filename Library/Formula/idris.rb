require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.19.tar.gz"
  sha256 "c9f73dcc61a8e24c56a13cf4397ea76ff1f0bf3d0d1004e92f972872aa73f1fd"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "9d1b027973addcb87af47059b5548dc2f64e30c78119c0ceabbbc8bb623440b0" => :el_capitan
    sha256 "05c45c28de89c39f9aee8300955622dd4e88373c1f0511be754782d60be4dedc" => :yosemite
    sha256 "2f8f3dad3067f4efaeb2a6d43370e2e67325cf3b9d66042fb5f5fff60711227b" => :mavericks
    sha256 "ec33fd58674dd8cb7557cd2f72bf0a90a105cdc4f4f8459520ff46014a15426b" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  depends_on "libffi" => :recommended
  depends_on "pkg-config" => :build if build.with? "libffi"

  setup_ghc_compilers

  def install
    flags = []
    flags << "-f FFI" if build.with? "libffi"
    flags << "-f release" if build.stable?
    install_cabal_package flags
  end

  test do
    (testpath/"hello.idr").write <<-EOS.undent
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS
    shell_output "#{bin}/idris #{testpath}/hello.idr -o #{testpath}/hello"
    result = shell_output "#{testpath}/hello"
    assert_match /Hello, Homebrew!/, result

    if build.with? "libffi"
      cmd = "#{bin}/idris --exec 'putStrLn {ffi=FFI_C} \"Hello, interpreter!\"'"
      result = shell_output cmd
      assert_match /Hello, interpreter!/, result
    end
  end
end
