class Newsbeuter < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsbeuter.org/"
  url "https://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
  sha256 "74a8bf019b09c3b270ba95adc29f2bbe48ea1f55cc0634276b21fcce1f043dc8"

  head "https://github.com/akrennmair/newsbeuter.git"

  bottle do
    cellar :any
    revision 2
    sha256 "c763ede64fb2bf9106fe720b54facf57efc992b24044c87af386d7e16413adb2" => :el_capitan
    sha256 "24235bf62ef863239ac94027455f75700db201c29929ccc226c973e674d58306" => :yosemite
    sha256 "381558b29bad7187433c935864ff9bb8c912419353239caf37c89833af4af225" => :mavericks
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
