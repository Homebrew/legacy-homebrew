require "language/go"

class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.1.0.tar.gz"
  sha256 "4e86e38677da12b235b14e5b2add9cea422f17a3cd14cd7358a262cdc8794a52"

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
