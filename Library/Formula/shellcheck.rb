require "formula"
require "language/haskell"

class Shellcheck < Formula
  include Language::Haskell::Cabal

  homepage "http://www.shellcheck.net"
  url "https://github.com/koalaman/shellcheck/archive/v0.3.2.tar.gz"
  sha1 "dd030c63f16e9170eb415176d101bbd2ce66fe00"

  bottle do
    cellar :any
    sha1 "903cdcdf9c39323152d6603bf36a48d470742805" => :mavericks
    sha1 "78456df525113ef15a979e4a943e39eaa9643e60" => :mountain_lion
    sha1 "e6f02857491301f0517627b103a7a719ac5521f9" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc" => :build
  depends_on "gmp"

  def install
    install_cabal_package
    system "make", "shellcheck.1"
    man1.install "shellcheck.1"
  end

  test do
    sh = testpath/"test.sh"
    sh.write <<-EOS.undent
      for f in $(ls *.wav)
      do
        echo "$f"
      done
    EOS
    assert `shellcheck -f gcc #{sh}`.include? "Iterate over globs whenever possible"
  end
end
