class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "https://www.vanheusden.com/rsstail/"
  url "https://www.vanheusden.com/rsstail/rsstail-2.0.tgz"
  sha256 "647537197fb9fb72b08e04710d462ad9314a6335c0a66fb779fe9d822c19ee2a"

  head "https://github.com/flok99/rsstail.git"

  bottle do
    cellar :any
    revision 1
    sha256 "e19aec49f4d56c6f9c062f3a107c2e55c470de49ee760c8087d9b432aaea796f" => :el_capitan
    sha256 "e118045780d62ac16ef413fe826be97afadd48390d6bba5b0d1ad221291507bb" => :yosemite
    sha256 "98f3b9fee8f7dc9e48a141bc9347c4a23eeca1ede249f5763a73835539c485db" => :mavericks
  end

  depends_on "libmrss"

  def install
    system "make"
    man1.install "rsstail.1"
    bin.install "rsstail"
  end

  test do
    assert_match(/^Title: NA-\d\d\d-\d\d\d\d-\d\d-\d\d$/,
                 shell_output("#{bin}/rsstail -1u http://feed.nashownotes.com/rss.xml"))
  end
end
