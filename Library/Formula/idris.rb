require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.20.tar.gz"
  sha256 "e3865785c0449029e6ccfe8169ef71cf3c1384b30439b0444b2d8523717f3a29"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "2b65cbe60a4dfb82472272dcd39306e04b4bced8adf1110aa62a0f32f359af8e" => :el_capitan
    sha256 "ff80db280fba81d749c48710e0c4eb5171e81b5cc57eaaec84fec0c79f2b636d" => :yosemite
    sha256 "bf2d18613061afcbe35e6f435aef023f3038a6bf45572d80a22ff11a298c5520" => :mavericks
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
