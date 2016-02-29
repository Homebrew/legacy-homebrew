require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.10.2.tar.gz"
  sha256 "3697808f06303f1d0a01708071ad2a580bf345bc0fc49e1cb3ee1cc139e99a9f"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "86a381352b9859d6c65172970753ad87e0ba7446b68c929f364d2488c8022119" => :el_capitan
    sha256 "6324ae196d2684ebb7e0b53c1f7e6f9b31827ee1969f72aa481de1b177a39832" => :yosemite
    sha256 "269885b9bd7b6931a88e2621427082088c4b3db896e3943b9cf0745732d1e63f" => :mavericks
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
