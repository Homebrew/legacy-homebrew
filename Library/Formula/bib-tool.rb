class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html"
  url "https://github.com/ge-ne/bibtool/archive/BibTool_2_63.tar.gz"
  sha256 "8834505834366bf2a1e23daea9d6aec786b893c40b7270291be78b2e4d0d1bb7"

  bottle do
    sha256 "00f739b22c53d932de1cf544ad0c35b6526c93e3a2970525767fb9fda205ac34" => :yosemite
    sha256 "c7d653318bc2d6bb91a439bb5600f161757962bd7952b4703d85d85c911dd34a" => :mavericks
    sha256 "3fc35d6bbda845e0678c773f7a518176bc683f30a50858bd3cf35b90df4de854" => :mountain_lion
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
