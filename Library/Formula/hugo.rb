class Hugo < Formula
  homepage "http://gohugo.io/"
  head "https://github.com/spf13/hugo.git"
  url "https://github.com/spf13/hugo/archive/v0.13.tar.gz"
  sha1 "a821fcde92b03baf49a45970d0ae6b781a3b12c1"

  bottle do
    cellar :any
    sha1 "efbab55fee9d1c74bd5dcf057cea1fc7932ea25d" => :yosemite
    sha1 "ac192894c709536377c9e7494278793ece613498" => :mavericks
    sha1 "ce38925c9dd8e24e052fcefe1de8fa17c1e3212a" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build
  depends_on :hg => :build

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath
    system "go", "get"
    system "go", "build", "main.go"
    bin.install "main" => "hugo"
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert File.exist?("#{site}/config.toml")
  end
end
