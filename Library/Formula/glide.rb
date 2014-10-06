require "formula"
require "language/go"

class Glide < Formula
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.2.0.tar.gz"
  sha1 "a01fc0a56cfcb9070af2e8bbca35da81310b0b21"

  bottle do
    sha1 "6f293dd28cd8648a468df50c47425ab9b44abd57" => :mavericks
    sha1 "d005e3f36eea13d35e727fc2d89f7a6ef1f6af7d" => :mountain_lion
    sha1 "f829adcff437950744190b5de6904db7548e81f4" => :lion
  end

  depends_on "go" => :build

  go_resource "github.com/kylelemons/go-gypsy" do
    url "https://github.com/kylelemons/go-gypsy.git",
      :revision => "0ddb27ce74ade2ca988ec85587d636e10312dfc6"
  end

  go_resource "github.com/Masterminds/cookoo" do
    url "https://github.com/Masterminds/cookoo.git",
      :revision => "b85ae3d2668c9a4e99419bd98ea9803926a1e306"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "f7ebb761e83e21225d1d8954fde853bf8edd46c4"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.2.0", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.2.0/, version
  end
end
