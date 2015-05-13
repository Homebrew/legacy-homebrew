require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://github.com/jgm/pandoc-citeproc/archive/0.7.0.1.tar.gz"
  sha256 "f672af320b808706657dcf578f4beef1b410cab744eab0707213e76687bd7a07"

  revision 1

  bottle do
    revision 1
    sha1 "7cb2d23e4bfa3a7f30156101db645e9fcc27a5a8" => :yosemite
    sha1 "94d27055eca1df4d2a928583f5e428f6bf5d6621" => :mavericks
    sha1 "b0093fe0c141c1c17a232909c595faee5285c564" => :mountain_lion
  end

  depends_on "ghc" => :build
  depends_on "cabal-install" => :build
  depends_on "pandoc"

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
