require "language/haskell"

class Pandoc < Formula
  include Language::Haskell::Cabal

  desc "Swiss-army knife of markup format conversion"
  homepage "http://pandoc.org"
  url "https://hackage.haskell.org/package/pandoc-1.15.0.6/pandoc-1.15.0.6.tar.gz"
  sha256 "d950968142526d5a765af7dfb26b47c3f60d4f883aa9d9eab668614179f1ed46"

  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 "6ce6666dc7f0436f011d8e3a8b15e92ae96c17c93156c560ba7e914c5c2e63dd" => :el_capitan
    sha256 "c0937b35c02d975d9c42d547eae6eef22f44c3f800b4369000b153265294458f" => :yosemite
    sha256 "45de8f7c956c415b9b94b46dec624f8c28d52fc46079721186bff9dd5bfc56e7" => :mavericks
    sha256 "129ba9b0fd78c82474f9d4b146efe5bac923a78700111e3a0b26398db5a30a54" => :mountain_lion
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
