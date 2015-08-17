require "language/go"

class Exercism < Formula
  desc "command-line tool to interact with exercism.io"
  homepage "http://cli.exercism.io"
  url "https://github.com/exercism/cli/archive/v2.2.1.tar.gz"
  sha256 "a4d71b98fc3e28f96868bcef140b3888a6fb85f942c4cbe168abaea253177aab"
  head "https://github.com/exercism.git"

  bottle do
    cellar :any
    sha256 "9959b2578131f7a19c234753277e535317a7d421f67bd384ea47f6cc2e886575" => :yosemite
    sha256 "4ab067a75cba97a079a5580c66f6d2be3e0927910bb04590671a98fd93b65882" => :mavericks
    sha256 "bac42ae1c756c328155b6561e5ae451683c3b5aff8824aa6e7b52445db27b1d4" => :mountain_lion
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
