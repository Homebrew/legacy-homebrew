require "language/haskell"

class Idris < Formula
  include Language::Haskell::Cabal

  homepage "http://www.idris-lang.org"
  url "https://github.com/idris-lang/Idris-dev/archive/v0.9.16.tar.gz"
  sha1 "01f794c4e516454b8352266c26c92549e90c708f"
  head "https://github.com/idris-lang/Idris-dev.git"

  bottle do
    sha1 "c25ba4b91264c187485111c5b8c18670c7f0441b" => :yosemite
    sha1 "df1773cb1800d6c629db9ba194666faf0019de31" => :mavericks
    sha1 "bbbe93cbd829bb02a9cdbb680805470f29702bbb" => :mountain_lion
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
      cmd = "#{bin}/idris --exec 'putStrLn \"Hello, interpreter!\"'"
      result = shell_output cmd
      assert_match /Hello, interpreter!/, result
    end
  end
end
