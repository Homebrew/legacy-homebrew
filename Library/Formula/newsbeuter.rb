class Newsbeuter < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "http://newsbeuter.org/"
  url "http://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
  sha256 "74a8bf019b09c3b270ba95adc29f2bbe48ea1f55cc0634276b21fcce1f043dc8"

  head "https://github.com/akrennmair/newsbeuter.git"

  bottle do
    cellar :any
    revision 1
    sha256 "15f454fa5f0c5cb2ee6b3c54fd312de8a1dbb7e38c5c90bbcf27bffd2536afaa" => :el_capitan
    sha256 "fa722fd5772e770f042461d3b68aefdc5d656a0073d1d0a8ed0a4cfa2b1e193e" => :yosemite
    sha256 "32bf15d33725a57bf5851e88f836b59a36b1715a26b2622bb759b19262998e59" => :mavericks
    sha256 "cfaa1d087980a62164a121d012eed12c5135b3d25f770d383215839d61428ba2" => :mountain_lion
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
