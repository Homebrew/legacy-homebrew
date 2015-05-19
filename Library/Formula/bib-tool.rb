class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html"
  url "http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-2.57.tar.gz"
  sha1 "a6e80c86d347a39f3883e552db2dd4deb72b0e86"

  bottle do
    sha1 "d5822fd899e1238c75964b7c0763dad2f24386e7" => :yosemite
    sha1 "dcaaf50c9992f1e1812845914ab3bd4b8be521de" => :mavericks
    sha1 "e0b9efe0a08a1c02a94ddd95fdfcef8863f1ad01" => :mountain_lion
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
