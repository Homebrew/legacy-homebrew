class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 6

  bottle do
    cellar :any
    sha256 "7a114550977788abddbcc318d0f232a1cc589cd239ae021425e755aa78bcf935" => :el_capitan
    sha256 "24553c34142d01f78fcdba39ce34cd45e5789619536e824b2cb7b03ef344292c" => :yosemite
    sha256 "3a4f19cb6486c97f444558a5f6c6069e7e4985cd5f07f9ff4f61778fd0a1f949" => :mavericks
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
