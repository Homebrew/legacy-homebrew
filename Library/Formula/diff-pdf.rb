class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 1

  bottle do
    cellar :any
    sha256 "b26623e692a4aca63ac3589b7a5c44ce1a9a74cf4b478a83103b74aba521dd3a" => :yosemite
    sha256 "62e062ad0b8ee16bca51c8516604eb5853e50263a62982262a73b502c9300d35" => :mavericks
    sha256 "513ffc6f1ffc54df0db5e49947a48c3cb2280c5143e78f8279dca900968a2cc6" => :mountain_lion
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
