require "formula"
require "language/go"

class Glide < Formula
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.1.0.tar.gz"
  sha1 "8323f0a9620d28fa1bc1b8514e2159ed0d27c135"

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
      :revision => "7020bd3519807e5e891fc73366551473dab38487"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "f7ebb761e83e21225d1d8954fde853bf8edd46c4"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.1.0", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide version")
    assert_match /0.1.0/, version
  end
end
