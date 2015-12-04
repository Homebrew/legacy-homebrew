class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "https://www.lri.fr/~filliatr/bibtex2html/"
  url "https://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.98.tar.gz"
  sha256 "e925a0b97bf87a14bcbda95cac269835cd5ae0173504261f2c60e3c46a8706d6"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "47096fa76ad63ac58cd9afd80d2a5589b70d178080dd48ed9c51639f4ff19e52" => :el_capitan
    sha256 "e3caa99e7bd5a6c00163642869e684680ee6e696b1ac3dc65425204c4b7be6b2" => :yosemite
    sha256 "77ece7804ba79ff217244fc52bf5a91fe3fbb65972da4edbcb8a5c5ce2d13e0b" => :mavericks
  end

  depends_on "ocaml"
  depends_on "hevea"
  depends_on :tex => :optional

  def install
    # See: https://trac.macports.org/ticket/26724
    inreplace "Makefile.in" do |s|
      s.remove_make_var! "STRLIB"
    end

    system "./configure", "--prefix=#{prefix}"
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
    system "#{bin}/bib2bib", "test.bib", "--remove", "pages", "-ob", "out.bib"
    assert /pages\s*=\s*{3--4}/ !~ File.read("out.bib")
    assert_match /pages\s*=\s*{3--4}/, File.read("test.bib")
  end
end
