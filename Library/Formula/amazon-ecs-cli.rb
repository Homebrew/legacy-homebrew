require "language/go"

class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.1.0.tar.gz"
  sha256 "4e86e38677da12b235b14e5b2add9cea422f17a3cd14cd7358a262cdc8794a52"

  bottle do
    cellar :any_skip_relocation
    sha256 "fa103532c4f19be2f1216e9364e55e7dd0d6c4d0418ed4620cc28fa2dc10fd16" => :el_capitan
    sha256 "9a734ae997bd8114d592f06dbdccb32927acb3501cf39e6e99131bf51ef5b620" => :yosemite
    sha256 "c823cfe2c34c06b3ad937edea1c040aaa7fd26037cf351f6c2a491196d648c43" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV.prepend_create_path "PATH", buildpath/"bin"

    clipath = buildpath/"src/github.com/aws/amazon-ecs-cli"
    clipath.install Dir["*"]

    Language::Go.stage_deps resources, buildpath/"src"

    ENV.append_path "PATH", buildpath/"bin"

    cd "src/github.com/aws/amazon-ecs-cli" do
      system "make", "build"
      bin.install "bin/local/ecs-cli"
    end
  end

  test do
    output = shell_output(bin/"ecs-cli --version")
    assert_match "ecs-cli version #{version} (*UNKNOWN)", output
  end
end
