class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.3.tar.gz"
  sha256 "f7fd69ff99cd48a77e53aed4219defaf1f45485a07978faec01c2b9074886e03"

  bottle do
    cellar :any
    sha256 "4224c373829ee8e51e378e47b3551119c425a2687e3916d6b1f3d3fd6bc99ea4" => :yosemite
    sha256 "2c08e12c60a2610053a24394161430a0f045cc32702828ad430894afcf9f4247" => :mavericks
    sha256 "a8b2aea4f2cf7f2be8c6d29049d2ad3dd75289c155ccc2c0ee70009e0d57b60c" => :mountain_lion
  end

  head do
    url "https://github.com/dreibh/bibtexconv.git"

    depends_on "automake" => :build
    depends_on "autoconf" => :build
    depends_on "libtool" => :build
  end

  depends_on "openssl"

  def install
    if build.head?
      inreplace "bootstrap", "/usr/bin/glibtoolize", Formula["libtool"].bin/"glibtoolize"
      system "./bootstrap"
    end
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # serialize folder creation
    system "make", "install"
  end

  test do
    cp "#{Formula["bibtexconv"].opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
