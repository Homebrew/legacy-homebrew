require "formula"
require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.6/pandoc-citeproc-0.6.tar.gz"
  sha1 "5236b4b4e201f94ab9f1bcd0d7e81c4271b46e8f"

  bottle do
    sha1 "6babd3e9d6264bcf678c5ea02140512c129528b4" => :mavericks
    sha1 "41af56ace751f9a5ac85618eb5d718fd1402d416" => :mountain_lion
    sha1 "b72a998686381016c0646264545c6bd554f3253e" => :lion
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
