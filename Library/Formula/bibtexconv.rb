class Bibtexconv < Formula
  homepage "https://www.iem.uni-due.de/~dreibh/bibtexconv/"
  url "https://www.uni-due.de/~be0001/bibtexconv/download/bibtexconv-1.1.0.tar.gz"
  sha1 "c9ea5d067de069ddbe7b6500043ff87cae2fb8ba"

  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    ENV.j1 # serialize folder creation
    system "make", "install"
  end

  test do
    cp "#{Formula["bibtexconv"].opt_share}/doc/bibtexconv/examples/ExampleReferences.bib", testpath

    system bin/"bibtexconv", "#{testpath}/ExampleReferences.bib", "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls", "-non-interactive"
  end
end
