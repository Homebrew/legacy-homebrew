require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.14.0.2/pandoc-1.14.0.2.tar.gz"
  sha256 "5d60bddc474499a2aa553e200da2860fed9e48a3db77072355f5f7c666a56bd0"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "0574980cdcb828c6106e2454b77d36f0f9098c601da8b7bd945146c93f5909a1" => :yosemite
    sha256 "086b3caa8e26cc764940d0ab502aeae9711862d5fbc3267c3aee5e6d69a64877" => :mavericks
    sha256 "ea5e61cdfaedd15e11637c3177d4c4c4af142a84cde744b7e7e47f7fe16474e2" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    system "pandoc", "-o", testpath/"output.html", prefix/"README"
    assert (testpath/"output.html").read.include? '<h1 id="synopsis">Synopsis</h1>'
  end
end
