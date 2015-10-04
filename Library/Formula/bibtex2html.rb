class Bibtex2html < Formula
  desc "BibTeX to HTML converter"
  homepage "http://www.lri.fr/~filliatr/bibtex2html/"
  url "http://www.lri.fr/~filliatr/ftp/bibtex2html/bibtex2html-1.98.tar.gz"
  sha256 "e925a0b97bf87a14bcbda95cac269835cd5ae0173504261f2c60e3c46a8706d6"

  bottle do
    cellar :any
    sha1 "e82686abe5a9c548d88345d7f42ec21aeb5dd8f6" => :yosemite
    sha1 "6ed6b299de0ef530d868c2b1c73ec7c428fc35d0" => :mavericks
    sha1 "32377bea1f584fedf5d2abb604a1d46e5e92ac5c" => :mountain_lion
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
