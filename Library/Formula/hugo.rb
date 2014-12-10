require "formula"

class Hugo < Formula
  homepage "http://hugo.spf13.com/"
  head "https://github.com/spf13/hugo.git"
  url "https://github.com/spf13/hugo/archive/v0.12.tar.gz"
  sha1 "f0537942cde9645ee2d98aaaf927a80c79070e99"

  bottle do
    sha1 "23432dd7d858c6642278791c6d5cbe23ff3dcfaa" => :mavericks
    sha1 "d5a6625b527670d753fe9c83c4fbc72c324ded18" => :mountain_lion
    sha1 "d3ad8b39b39597890401bac9cfbb0fc8f4ac9434" => :lion
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
