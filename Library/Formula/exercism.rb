require "language/go"

class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.2.0.tar.gz"
  sha256 "f044645c7e775abcf721939f015fb51df8733a0acf828961e6ebefee57194b03"
  head "https://github.com/exercism.git"

  depends_on "go" => :build

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "bca61c476e3c752594983e4c9bcd5f62fb09f157"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
      :revision => "6e7f843663477789fac7c02def0d0909e969b4e5"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git",
      :revision => "d9558e5c97f85372afee28cf2b6059d7d3818919"
  end

  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
      :revision => "3eb7007b740b66a77f3c85f2660a0240b284115a"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    path = buildpath/"src/github.com/exercism/cli"
    path.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    cd path do
      system "go", "build", "./exercism/main.go"
    end

    bin.install path/"main" => "exercism"
  end

  test do
    assert_equal "exercism version #{version}",
      shell_output("#{bin}/exercism --version").strip
  end
end
