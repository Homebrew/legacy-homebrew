require "language/go"

class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.2.1.tar.gz"
  sha256 "c3056bcae583fd6966e3dc9e60ba96ffb23679bfc5671a5d8d4d7bfe6c2e5d73"

  bottle do
    cellar :any_skip_relocation
    sha256 "90fb4508ef68c9b9b10d7cab0aafac886957af4d36124ecb88a4d66cc380b6fc" => :el_capitan
    sha256 "53a30e2b1b9546bc254371578b36fed9f498c62f40b0cbf736d91d2aab9b63ca" => :yosemite
    sha256 "28174de24dbe7f21b527db10f4474402ef11bd675cef5d7601ebce1f2aa9686f" => :mavericks
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
