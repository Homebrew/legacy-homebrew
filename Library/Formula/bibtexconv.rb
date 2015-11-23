class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https://www.uni-due.de/~be0001/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.3.tar.gz"
  sha256 "f7fd69ff99cd48a77e53aed4219defaf1f45485a07978faec01c2b9074886e03"
  revision 1

  bottle do
    cellar :any
    sha256 "1bd6912245b0f2b9dfaa69729633e20b6843bf24141f6f7d03a437ec8593df7d" => :yosemite
    sha256 "93e1e693a5688ef09514412752ade4272d04f918810b6e4b76e7a7060f783b9a" => :mavericks
    sha256 "a571ad33e62649abf68d26a569de9f7ba013202022883d684f243144feeffcdb" => :mountain_lion
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
    cp "#{opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end
