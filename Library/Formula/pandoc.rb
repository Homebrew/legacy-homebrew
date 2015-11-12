require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.1.1/pandoc-1.15.1.1.tar.gz"
  sha256 "a70e0af56c294dbb1ba646df24f90b81542d060ec7167f70ff2b873ed7ed6d5e"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "3aaa65bd43d3d768d06fff00e58af6ec976a78ca6837469c1fbbae5b7e4d194d" => :el_capitan
    sha256 "8d23b249fb30ef98e92c7ca0f4d783d05d96c4e4bfc054fe27a54b858db84025" => :yosemite
    sha256 "dad2a70cddd0e0bf2d17970471942c4005f7da71fc0f735f0b5f402792dc0782" => :mavericks
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
