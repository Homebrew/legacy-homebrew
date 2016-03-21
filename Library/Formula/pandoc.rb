require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17/pandoc-1.17.tar.gz"
  sha256 "7e9fefd1a9f5fb1ba889f75785788ac4abb360dd5fb9611e57a9c94734580e26"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "d2de23dda70873b0d58229e4fe994c55af251b76c020eb79b0cb1c23caaeee05" => :el_capitan
    sha256 "30dde4679b3fc5979c1931da3fb35c2810fb00a362a5fa148bbfba1ccf10e33e" => :yosemite
    sha256 "3bd1d616d5a787bdddce9f6546a9c108aef3b4df094d242984ee790626433fc5" => :mavericks
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
