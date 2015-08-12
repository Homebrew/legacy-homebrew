require "language/go"

class AmazonEcsCli < Formula
  desc "CLI for Amazon ECS to manage clusters and tasks for development."
  homepage "https://aws.amazon.com/ecs"
  url "https://github.com/aws/amazon-ecs-cli/archive/v0.2.1.tar.gz"
  sha256 "c3056bcae583fd6966e3dc9e60ba96ffb23679bfc5671a5d8d4d7bfe6c2e5d73"

  bottle do
    cellar :any_skip_relocation
    sha256 "6b40724d56012f9905dc0a90263a655c924cf4ea248819704b7acbf8c816513b" => :el_capitan
    sha256 "b64969a0b343f9b2da32bfe3587b0b8ccb725ab79a854a78d724a79b1788b340" => :yosemite
    sha256 "81ce218cc1271383664eb7e3a42276d90bc0254b9a2bae1c179ce97d9f10979c" => :mavericks
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
