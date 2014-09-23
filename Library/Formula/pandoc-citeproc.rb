require "formula"
require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.4.0.1/pandoc-citeproc-0.4.0.1.tar.gz"
  sha1 "41c71939d78bfe52f4dd06ca3d7a6b4d824cdd47"

  bottle do
    sha1 "e1a339c04e78a4d7fba542336e655f24fa029bbe" => :mavericks
    sha1 "b00f823667e3a2775388758af7ed309ddc5a761e" => :mountain_lion
    sha1 "332eb0a1d2754606f74731e30ee3e76320947389" => :lion
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
