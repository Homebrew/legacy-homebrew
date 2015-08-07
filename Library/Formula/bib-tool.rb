class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html"
  url "https://github.com/ge-ne/bibtool/releases/download/BibTool_2_61/BibTool-2.61.tar.gz"
  sha256 "8eaf351f1685078345a4446346559698fb58d8d1dfdf057418e5221132f9a8a4"

  bottle do
    sha256 "62861fe6407c2953ada2a8066ac23790b52eeab4c748a893a64358cffb7149e4" => :yosemite
    sha256 "589bd5d8c386cd9c87cf4a3b7b637f3a65ac449c1e0fc632dd88902ecf9e57f4" => :mavericks
    sha256 "2023b312b178d1bcac02af7cd1dfbb2fd0a0edd4c8c48c30b38bea2ee0336ab7" => :mountain_lion
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--without-kpathsea"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.bib").write <<-EOS.undent
      @article{Homebrew,
          title   = {Something},
          author  = {Someone},
          journal = {Something},
          volume  = {1},
          number  = {2},
          pages   = {3--4}
      }
    EOS
    system "#{bin}/bibtool", "test.bib"
  end
end
