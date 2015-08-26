require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.18.1.tar.gz"
  sha256 "ba09b15cb188e7e8ef8a9cb36aa0a847415cdaf36b26c3a95d8a2063d3373e34"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "947b6f2391432a13a2fd8cf6584568a0e20c3822f3c61f0c2283b53555d04110" => :yosemite
    sha256 "f957240b69b7a9af70e80370f41c0bfc98daca655e2a55330d53134ea6601081" => :mavericks
    sha256 "402a3181054aa0d9e6058f5b7c23de758dd544148d97214268c95ce9b05f5928" => :mountain_lion
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
