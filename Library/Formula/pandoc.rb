require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.17/pandoc-1.17.tar.gz"
  sha256 "7e9fefd1a9f5fb1ba889f75785788ac4abb360dd5fb9611e57a9c94734580e26"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "a424ef179a8c8e3db8002e80bb1be851157e9b7bc809bdf62630bd0e7cbc913b" => :el_capitan
    sha256 "7fb2340adfe9ac8ed39d844440e04bdf0072e2afa704140f0fe44b07ef905db2" => :yosemite
    sha256 "d3d82a8526221b647debec02301e453eda13fa2df5eea6e1ae6b48cf15281a2f" => :mavericks
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
