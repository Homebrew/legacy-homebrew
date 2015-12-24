require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.20.2.tar.gz"
  sha256 "3b89b24d07c6cd647c83b45fdede3f12fe3d07fbdefdd0b9023020beae3ad74e"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "2898137b0919706d081d61966eca7fcac3b565923a0d80ca539a6e40c95cc337" => :el_capitan
    sha256 "ce08aae305a0db1b943eb914e3f4fece8b2f970aa3ac1e02e35ca747c7e9353b" => :yosemite
    sha256 "ba265e4acf5a41e62dc4e199766c0b515f7c2529847dd85d91263ba9128ba7db" => :mavericks
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
