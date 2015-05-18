require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.18.tar.gz"
  sha1 "08b863ab13c306b2643e63a2bb76a01b0305c20d"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha256 "bb4ac9869a6dc76d6b4a8ecb4e6edc2ae476872432f71509134d1c47e51abdee" => :yosemite
    sha256 "69b0bbf45713c1819696bffd870c2f74fa7ff3e8b5d68dc1b96e194579ce3f13" => :mavericks
    sha256 "bb2d159e3626c95e2f23c20b1e3020151a6ab928b7606fb6790b701360735769" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  depends_on "libffi" => :recommended
  depends_on "pkg-config" => :build if build.with? "libffi"

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
