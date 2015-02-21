class Newsbeuter < Formula
  homepage "http://newsbeuter.org/"
  url "http://www.newsbeuter.org/downloads/newsbeuter-2.9.tar.gz"
  sha1 "e0d61cda874ea9b77ed27f2edfea50a6ea471894"

  head "https://github.com/akrennmair/newsbeuter.git"

  bottle do
    cellar :any
    sha1 "c0ba075c6d235a851361bc6315ad81ba8a93593f" => :yosemite
    sha1 "ba32930fd5e0213b160d39a3bce1138b3661b4f6" => :mavericks
    sha1 "4c8e48932bacd4c7cc0d2ff7ec2c583d99692855" => :mountain_lion
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
