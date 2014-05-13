require "formula"

class Hugo < Formula
  homepage "http://hugo.spf13.com/"
  head "https://github.com/spf13/hugo.git"
  url "https://github.com/spf13/hugo.git", :tag => "v0.11"
  sha1 "eb036b11d915bf78d0d679ee14ec065458977e2e"

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
