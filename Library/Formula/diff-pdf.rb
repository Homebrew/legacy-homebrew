class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 4

  bottle do
    cellar :any
    sha256 "29760dcb0cfb5965153f55ead9ee64536181aad457e49c75d1fb10d6f2ed057a" => :el_capitan
    sha256 "389cc62351e09eda9e2e451fc02bbce77e5f4e8263a7706d8cf0c99af3a50d1d" => :yosemite
    sha256 "8d03293ec31a1a97162942d30031e88230f084c7aba3ad2a79e93a23a75a819e" => :mavericks
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
