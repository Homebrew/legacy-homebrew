require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.16.0.2/pandoc-1.16.0.2.tar.gz"
  sha256 "f5f3262ef4574a111936fea0118557c523a8b0eaa7fea84b64b377b20a80f348"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "b41aec13628331db94c3d6e49b3f57b7e3cc9d84262cdf9ec0995230e68c799b" => :el_capitan
    sha256 "8745651aca1b3fd3727c1a80a4b1ee10084ac0b52300258b65635125686f5203" => :yosemite
    sha256 "0478ec953e78f4aafc98fa298dea60bf26a8528db83246cca1c931f9f623c232" => :mavericks
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
