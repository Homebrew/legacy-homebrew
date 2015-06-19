require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.18.tar.gz"
  sha1 "08b863ab13c306b2643e63a2bb76a01b0305c20d"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "f7452fb8719478d033473dc7a655f1ffae44bbccf2a2999a2b42c483363de318" => :yosemite
    sha256 "5c0d4067a4284b4d551ed05824151071463d07493ffb406145e118d7f537d522" => :mavericks
    sha256 "96c8ee3754b782fddfb879ab6db9a8ad0b247b9b5a83fb91943c07fc767ed101" => :mountain_lion
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
