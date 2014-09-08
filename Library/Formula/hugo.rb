require "formula"

class Hugo < Formula
  homepage "http://hugo.spf13.com/"
  head "https://github.com/spf13/hugo.git"
  url "https://github.com/spf13/hugo.git", :tag => "v0.11"
  sha1 "eb036b11d915bf78d0d679ee14ec065458977e2e"

  bottle do
    sha1 "71713846fe6611c6059cbbb811c1bad69fe52a8e" => :mavericks
    sha1 "f5a265c90d90a8d7c072dc62b7a4b51fe7685a6f" => :mountain_lion
    sha1 "180267e5b98d62605531a3e9ce7e54088f855e08" => :lion
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build
  depends_on :hg => :build

  def install
    ENV["GIT_DIR"] = cached_download/".git" if build.head?
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
