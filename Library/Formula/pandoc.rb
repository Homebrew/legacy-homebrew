require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.2.1/pandoc-1.15.2.1.tar.gz"
  sha256 "60bcb0e65ecb63953dd26d5aacf1a5df83700d116062ffaeffe9edbc9be6df59"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "872d03107276a48edccba99db5da657010a67b8906a9b96c68f825440a2fcac0" => :el_capitan
    sha256 "bb44b6757591f9ab42d0e53a7fd19373c5c9ac9eb7363849df285f248c336b5b" => :yosemite
    sha256 "7fcd5821bc01589340a41e5b215c86b2a480599c6ec337c0397adfdd9c6b758e" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  setup_ghc_compilers

  def install
    cabal_sandbox do
      args = []
      args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
      cabal_install "--only-dependencies", *args
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
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
