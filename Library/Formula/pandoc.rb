require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.2/pandoc-1.15.2.tar.gz"
  sha256 "9c6ffe77006513306b35daa7256c1625c6eaf2e16a8de8fe5248f20015c3d335"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "7dc47fef5bf0998f47b46c942541e6682c02b4784666a0ecca1821b2a3ffdac7" => :el_capitan
    sha256 "d56d08a75e2fc7492b2a38f028e2ca123673319c1480efab5d7cfa6dad016fde" => :yosemite
    sha256 "498a9ea32ca532cb3dc2257ae10b19d9169c21a54b354ea77c329fcffd3c6409" => :mavericks
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
