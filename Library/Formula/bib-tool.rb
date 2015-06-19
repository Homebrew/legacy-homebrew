# This is needed because of a problem with the tarball for 2.60
# Hopefully, it will not be needed for future releases
# See https://github.com/Homebrew/homebrew/issues/40559
class BibToolDownloadStrategy < CurlDownloadStrategy
  def stage
     with_system_path { safe_system 'tar', 'xqf', cached_location, 'BibTool/doc/bibtool.tex' }
     with_system_path { safe_system 'tar', 'xf', cached_location, '--exclude', 'BibTool/doc/bibtool.tex' }
     chdir
  end
end

class BibTool < Formula
  desc "Manipulates BibTeX databases"
  homepage "http://www.gerd-neugebauer.de/software/TeX/BibTool/index.en.html"
  url "http://www.gerd-neugebauer.de/software/TeX/BibTool/BibTool-2.60.tar.gz",
    :using => BibToolDownloadStrategy
  sha256 "db84b264df7c069b5b1c8e0778dc70f4e335cd1c39d711dcd65bae02df809ad1"

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
