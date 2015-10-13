class DiffPdf < Formula
  desc "Visually compare two PDF files"
  homepage "https://vslavik.github.io/diff-pdf/"
  url "https://github.com/vslavik/diff-pdf/archive/v0.2.tar.gz"
  sha256 "cb90f2e0fd4bc3fe235111f982bc20455a1d6bc13f4219babcba6bd60c1fe466"
  revision 3

  bottle do
    cellar :any
    sha256 "d76a363151baa7c213905063d422d5de38c24ea8b6d83d0dac3e417fcd71a504" => :el_capitan
    sha256 "1b7b2e0ecbb75f242ab28a7f77afb8bce89bd659f38367befbe9b96a017f57d3" => :yosemite
    sha256 "321623ec3702a50c4caf7bb97f51837501d12e84569ba5acca115dc8fb232e88" => :mavericks
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
