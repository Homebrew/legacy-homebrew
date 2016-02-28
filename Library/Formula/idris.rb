require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.10.2.tar.gz"
  sha256 "3697808f06303f1d0a01708071ad2a580bf345bc0fc49e1cb3ee1cc139e99a9f"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "f98fd8a486f8055d5b92413e510c9d13276de50df2962e24d6180f8a3a3b8cd0" => :el_capitan
    sha256 "50b2ce881aadb6fddf6bb656c770cdeae40fc7dacb9b7e63ea1aeb8b25d50040" => :yosemite
    sha256 "546f7ee78700c0b42f35677244c801320c9cd908a1c12e846dcb2f8d3aeaf3b1" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  depends_on "libffi" => :recommended
  depends_on "pkg-config" => :build if build.with? "libffi"

  def install
    args = []
    args << "-f FFI" if build.with? "libffi"
    args << "-f release" if build.stable?
    install_cabal_package *args
  end

  test do
    (testpath/"hello.idr").write <<-EOS.undent
      module Main
      main : IO ()
      main = putStrLn "Hello, Homebrew!"
    EOS

    (testpath/"ffi.idr").write <<-EOS.undent
      module Main
      puts: String -> IO ()
      puts x = foreign FFI_C "puts" (String -> IO ()) x

      main : IO ()
      main = puts "Hello, interpreter!"
    EOS
    shell_output "#{bin}/idris #{testpath}/hello.idr -o #{testpath}/hello"
    result = shell_output "#{testpath}/hello"
    assert_match /Hello, Homebrew!/, result

    if build.with? "libffi"
      shell_output "#{bin}/idris #{testpath}/ffi.idr -o #{testpath}/ffi"
      result = shell_output "#{testpath}/ffi"
      assert_match /Hello, interpreter!/, result
    end
  end
end
