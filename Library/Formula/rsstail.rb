class Rsstail < Formula
  desc "Monitors an RSS feed and emits new entries when detected"
  homepage "http://www.vanheusden.com/rsstail/"
  url "http://www.vanheusden.com/rsstail/rsstail-2.0.tgz"
  sha256 "647537197fb9fb72b08e04710d462ad9314a6335c0a66fb779fe9d822c19ee2a"

  head "https://github.com/flok99/rsstail.git"

  bottle do
    cellar :any
    sha256 "8ed1aaca7c992bf95097a85fef0afb82601056217e0a5992c03276be407cedfa" => :yosemite
    sha256 "40d3d3b8f001e4be990b5280faa46cc577d8f77c4b82445759bb2a017ebb8d56" => :mavericks
    sha256 "35d9f648c3081a208b555739b80fd26002a0182a3c8571e836e9f7152c38c76f" => :mountain_lion
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
