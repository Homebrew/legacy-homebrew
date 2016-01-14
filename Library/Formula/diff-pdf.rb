class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 7

  bottle do
    cellar :any
    sha256 "a7a636072f859ca867a9f3d164211472d5399a90cd43aa9cb0ed60c9a7e02e70" => :el_capitan
    sha256 "a6bee15b632e66a659ed3c5b97fa61cbd43e557f9b68b42dec2603d075ee6c1c" => :yosemite
    sha256 "f55e3fe3bc88877c82b4639d4a5dd2ba367cb87c1ccf33db25e23f471ea10a26" => :mavericks
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
