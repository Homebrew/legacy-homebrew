class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 6

  bottle do
    cellar :any
    sha256 "ee8864008500298e1e0f379210760a45b700ad7dfb7b7116dfaf215fd19ebcd2" => :el_capitan
    sha256 "86647984e7073ece08bed383d180a12dbb9359716830c86ff2afbae56a5cffc1" => :yosemite
    sha256 "0c9941602950cffdda734c64fed1b752137fdd1663362ed5bbb4ca21783615fb" => :mavericks
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
