class Newsbeuter < Formula
  homepage "http://newsbeuter.org/"
  url "http://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
  sha1 "e0d61cda874ea9b77ed27f2edfea50a6ea471894"

  head "https://github.com/akrennmair/newsbeuter.git"

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
  end

  test do
    urlfile = "urls.txt"
    (testpath/urlfile).write "https://github.com/blog/subscribe\n"
    assert_match /newsbeuter - Exported Feeds/m, shell_output("#{bin}/newsbeuter -e -u #{urlfile}")
  end
end
