require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.16/pandoc-1.16.tar.gz"
  sha256 "20c0b19a6bf435166da3b9e400c021b90687d8258ad1a0aecfc49fce1f2c6d0c"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3d4e1543afa929a2459a2bfc81ec3153e9d3055e22e7cfe148cda80d20648f0b" => :el_capitan
    sha256 "ccb27aa10938b566364dd40a98e5e809a6d3864fa4c2033031dffdec23c4c59e" => :yosemite
    sha256 "035c28dd5e36975d1425be4ae7c1b46d20f7242ba024501b47e15af59762296c" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
  end

  test do
    input_markdown = <<-EOS.undent
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<-EOS.undent
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
