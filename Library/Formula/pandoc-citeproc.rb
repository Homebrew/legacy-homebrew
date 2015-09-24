require "language/haskell"

class PandocCiteproc < Formula
  include Language::Haskell::Cabal

  desc "Library and executable for using citeproc with pandoc"
  homepage "https://github.com/jgm/pandoc-citeproc"
  url "https://hackage.haskell.org/package/pandoc-citeproc-0.7.4/pandoc-citeproc-0.7.4.tar.gz"
  sha256 "905112d8995fb6de5ee4c4bfd62cc89baa3bf1598f258aaba1704f85cf739fd2"

  bottle do
    sha256 "d2a89b600da92b8bef78fe25c4c3276f0286d74297d47078853602df0a5e9b27" => :el_capitan
    sha256 "35fe5761b6c4d70cc155997ea053aed166ea35e02f05427302bc72c3cbe6a3f5" => :yosemite
    sha256 "aa3afb6ca61dad0dde8325d83a23cce37311da09388baf9571c598617591a82e" => :mavericks
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
