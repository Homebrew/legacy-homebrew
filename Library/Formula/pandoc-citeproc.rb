require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.6/pandoc-citeproc-0.6.tar.gz"
  sha1 "5236b4b4e201f94ab9f1bcd0d7e81c4271b46e8f"

  bottle do
    revision 1
    sha1 "7cb2d23e4bfa3a7f30156101db645e9fcc27a5a8" => :yosemite
    sha1 "94d27055eca1df4d2a928583f5e428f6bf5d6621" => :mavericks
    sha1 "b0093fe0c141c1c17a232909c595faee5285c564" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"
  depends_on "pandoc" => :recommended

  fails_with(:clang) { build 425 } # clang segfaults on Lion

  def install
    cabal_sandbox do
      cabal_install "--only-dependencies"
      cabal_install "--prefix=#{prefix}"
    end
    cabal_clean_lib
  end

  test do
    bib = testpath/"test.bib"
    bib.write <<-EOS.undent
      @Book{item1,
      author="John Doe",
      title="First Book",
      year="2005",
      address="Cambridge",
      publisher="Cambridge University Press"
      }
    EOS
    assert `pandoc-citeproc --bib2yaml #{bib}`.include? "- publisher-place: Cambridge"
  end
end
