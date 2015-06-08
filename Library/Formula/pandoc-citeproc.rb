require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.7.1.1/pandoc-citeproc-0.7.1.1.tar.gz"
  sha256 "415d97bafa36b7807a78747c2dd9a5e80042d0ad6de99e2ec3c13213e87926d9"

  bottle do
    sha256 "dd3818119bc6c51a663ab68e649a56a48e807999725f1ad91bde0b6cbf9e8c91" => :yosemite
    sha256 "420ab2e0c96254fdac500eeb36b66dcdb98f897d71fff7174f9cab935b4b6e94" => :mavericks
    sha256 "4b7759dd9857396dbe027512a0aba418dc0993f891f672ef883c0a0e06d09485" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  setup_ghc_compilers

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
    system "pandoc-citeproc", "--bib2yaml", bib
  end
end
