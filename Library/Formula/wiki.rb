require "language/go"

class Wiki < Formula
  desc "Fetch summaries from MediaWiki wikis, like Wikipedia"
  homepage "https://github.com/walle/wiki"
  url "https://github.com/walle/wiki/archive/1.3.0.tar.gz"
  sha256 "c12edcaed5c9d5e69fc43e77713a68948a399017467d248ba59367b5d458a9e6"

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
      :revision => "40e4aedc8fabf8c23e040057540867186712faa5"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    wikipath = buildpath/"src/github.com/walle/wiki"
    wikipath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/walle/wiki" do
      system "go", "build", "-o", "build/wiki", "cmd/wiki/main.go"
      bin.install "build/wiki"
      man1.install "_doc/wiki.1"
    end
  end

  test do
    assert_match "Read more: https://en.wikipedia.org/wiki/Go", shell_output("#{bin}/wiki golang")
  end
end
