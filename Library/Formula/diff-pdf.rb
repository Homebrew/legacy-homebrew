class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 2

  bottle do
    cellar :any
    sha256 "24c3f3a6e643e9e845b0e0a067ef064cd60cf8abb8410e3ca2f3d92a57f36fe5" => :yosemite
    sha256 "0d90a83b87dc2988ab23474a7ed8477d10aa99f748de277a3501ac33b9a365e8" => :mavericks
    sha256 "5c9d929f810b846ce9aad49d00d0b3edea43c20b322496bad4a3179baa224ba7" => :mountain_lion
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
