class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 8

  bottle do
    cellar :any
    sha256 "e66e29a451134d21cc8489d3fce24491d6c767af7f6180d2bc951ac4b60550c8" => :el_capitan
    sha256 "d3e8ee0c162deee52c89e10c1bc880a6ff6f7de417b7ff430fd5b7ebd764000b" => :yosemite
    sha256 "2d24225b7aee93d7e7999b1c4123de453c519af4ac23030bbad44de8e461952c" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "automake" => :build
  depends_on "autoconf" => :build
  depends_on :x11
  depends_on "wxmac"
  depends_on "cairo"
  depends_on "poppler"

  def install
    system "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/diff-pdf", "-h"
  end
end
