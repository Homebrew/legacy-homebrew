require "language/go"

class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.2.4.tar.gz"
  sha256 "730d5ab21d7497c223f113f98829d56b9309d165b95bb666b0afc9148bffe2b1"
  head "https://github.com/exercism.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "558b364e2cdbd6e11e3af8da96aebf3b267b6b9a114305761d8f8c557c49c2e2" => :el_capitan
    sha256 "4096dcbcbc76a8ff0729dd2763f59040903ab7e0feacfb45ba0b003356826061" => :yosemite
    sha256 "18941c1dc1be5abfcf8cfd619e484f6c25ef3fe55f1c47c547cea455c367b1d3" => :mavericks
  end

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
