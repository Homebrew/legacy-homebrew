class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "http://www.vanheusden.com/rsstail/"
  url "http://www.vanheusden.com/rsstail/rsstail-2.0.tgz"
  sha256 "647537197fb9fb72b08e04710d462ad9314a6335c0a66fb779fe9d822c19ee2a"

  head "https://github.com/flok99/rsstail.git"

  bottle do
    cellar :any
    sha256 "0d18005ca03757ba45acb78737587eeb9abbe31e5346b0a0738dbc63951a3311" => :yosemite
    sha256 "1ec19466e92bbeae9ed3b9e4f9ea9af18eabfd7c8c86e74eda409271028d1b3e" => :mavericks
    sha256 "b17a2996711143d24d0a85ecfe26592b4ad9927e2f42e22af7289abe4e5bc4f5" => :mountain_lion
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
