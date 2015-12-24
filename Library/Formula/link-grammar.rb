class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "http://www.abisource.com/projects/link-grammar/"
  url "http://www.abisource.com/downloads/link-grammar/5.3.3/link-grammar-5.3.3.tar.gz"
  sha256 "832e1aa61d5eafbb7d3f4429847125067dcb6a3ece8c55ee8ffb1cd8c8db57d4"

  bottle do
    sha256 "7a95ab8e3cb206cc534588c9991fdc7c9b4774d61abcadf40051a7d782957403" => :el_capitan
    sha256 "b8aa7f4c829d15aeceb8eb3e7ebf7006e7b4f1a6a9e64f0d67b59f85472216d0" => :yosemite
    sha256 "e4cf2295ccd5db52f0dbddc30f62e254745e48f42f3e0ae2feb585cbc48385d9" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on :ant => :build

  def install
    inreplace "autogen.sh", "libtoolize", "glibtoolize"
    system "./autogen.sh", "--no-configure"
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
