require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  desc "Pure functional programming language with dependent types"
  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.20.2.tar.gz"
  sha256 "3b89b24d07c6cd647c83b45fdede3f12fe3d07fbdefdd0b9023020beae3ad74e"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "ac4f5907e49ccf6289f64abe999e76f5d3ec4172e36445d8a7333cd6f55d4f37" => :el_capitan
    sha256 "97ebe63827aa4b3ae9d6c23ba4fc2369f0c7a415542d8acc69b3a28d1cc7e956" => :yosemite
    sha256 "dc924f92f5de15482cc2305b79a68a677be2fb7eade752bbc2898893f9033153" => :mavericks
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
