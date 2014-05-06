require "formula"
require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "http://hackage.haskell.org/package/pandoc-citeproc-0.3.0.1/pandoc-citeproc-0.3.0.1.tar.gz"
  sha1 "958309f9996d563ffba0bd4870bb7f201aac08e8"

  bottle do
    sha1 "e94a82ea226531abb6be5da81305f6f71e55a92e" => :mavericks
    sha1 "123132215cb70fb6b7253d6cf26d43e463385a79" => :mountain_lion
    sha1 "58092e747a0ce49b2975efcae3ec7b643225863a" => :lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "gmp"

  def install
    cabal_sandbox do
      cabal_install_tools "alex", "happy"
      cabal_install "--only-dependencies", "--constraint=temporary==1.2.0.1"
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
