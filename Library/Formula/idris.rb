require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.20.1.tar.gz"
  sha256 "230acb347b773a8617ffda542e4e24e6e24cc2ce59b5f600ffe0f5a8f777ae8c"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "12958bbed0ead212733100296b6b87dd147dbfa3b1aee92c588a7709f91c460d" => :el_capitan
    sha256 "e0f61a40a1e810a86071d936fe64285fa9b275888c54445afe7e7593839f9705" => :yosemite
    sha256 "1819af3d2f0c9188910848ae6581c1479671c2cc84ebb3d608d7c2c44eaae893" => :mavericks
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
