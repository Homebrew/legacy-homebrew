require "formula"
require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.4.0.1/pandoc-citeproc-0.4.0.1.tar.gz"
  sha1 "41c71939d78bfe52f4dd06ca3d7a6b4d824cdd47"

  bottle do
    sha1 "2618b1e023b264474fd89b9d6e824bca80397043" => :mavericks
    sha1 "7785694f8d11478a04f6cc6b02370655ba9a20bc" => :mountain_lion
    sha1 "f891ee011d1de27eca51e17e9f9e7dc9baf75e0f" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"
  depends_on "pandoc" => :recommended

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
