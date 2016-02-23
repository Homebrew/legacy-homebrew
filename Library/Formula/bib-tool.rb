class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html"
  url "https://github.com/ge-ne/bibtool/archive/BibTool_2_63.tar.gz"
  sha256 "8834505834366bf2a1e23daea9d6aec786b893c40b7270291be78b2e4d0d1bb7"

  bottle do
    sha256 "a2e9214289b1d13514bdbe88531e270056c698aa0f9cb391fd0b1f64880104ca" => :el_capitan
    sha256 "cd5727fee0530b7e67c252e83a9d184025ed45980088da89700146eadd2c5154" => :yosemite
    sha256 "f96f81ee186c5f9cf5c827c52951d5f40b2f1458bcf1995fd551c8093f6070cc" => :mavericks
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
