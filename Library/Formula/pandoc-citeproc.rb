require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.9/pandoc-citeproc-0.9.tar.gz"
  sha256 "ae880aa27b5fcaf93886844bd9473c764329dc96211482bf014f350335887fbd"

  bottle do
    sha256 "8b2b518f68c14e679ddb069386dd2f158c2c1a36a90ac7f6c321abbc54467c4c" => :el_capitan
    sha256 "c544453b5305e5f317ca820c0df40edbe791992288d29bd1e777516d790d8c38" => :yosemite
    sha256 "5b5ca08d646fab7ba22888540904fab55606ca14e2e526d582a170b55aca76c6" => :mavericks
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

  def install
    args = []
    args << "--constraint=cryptonite -support_aesni" if MacOS.version <= :lion
    install_cabal_package *args
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
