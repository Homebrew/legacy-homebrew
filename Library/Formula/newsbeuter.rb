class Newsbeuter < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "http://newsbeuter.org/"
  url "http://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
  sha1 "e0d61cda874ea9b77ed27f2edfea50a6ea471894"

  head "https://github.com/akrennmair/newsbeuter.git"

  bottle do
    cellar :any
    revision 1
    sha256 "15f454fa5f0c5cb2ee6b3c54fd312de8a1dbb7e38c5c90bbcf27bffd2536afaa" => :el_capitan
    sha1 "6c509202d95792b56d6c14c335cf230a297ac6d0" => :yosemite
    sha1 "8521be744f61fa39d95480625562ed12ba295656" => :mavericks
    sha1 "973c64d2807a77163ee48c72da89748c75b0e880" => :mountain_lion
  end

  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"
  depends_on "sqlite"

  needs :cxx11

  def install
    ENV.cxx11
    system "make"
    system "make", "install", "prefix=#{prefix}"

    share.install "contrib"
    (doc/"examples").install "doc/example-bookmark-plugin.sh"
  end

  test do
    urlfile = "urls.txt"
    (testpath/urlfile).write "https://github.com/blog/subscribe\n"
    assert_match /newsbeuter - Exported Feeds/m, shell_output("#{bin}/newsbeuter -e -u #{urlfile}")
  end
end
