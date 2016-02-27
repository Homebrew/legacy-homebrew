require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.12.tar.gz"
  sha256 "a8c4877547f8f02887c03328582ad2a43ea113a351f545e073f32e74d172e8a2"

  bottle do
    cellar :any_skip_relocation
    sha256 "9218bb3e09d27f0af1b83107fc4818830f63ef226403e24d5b8cb42f797f06a9" => :el_capitan
    sha256 "a4610b66aa44487fdddd21d4fa94cc094a4f70819bf56b71c810a38cb564e7e8" => :yosemite
    sha256 "a230bbf661ee1b472e0af9ed6066361b101a79b07e5d4cf2cbd0e99c043bcda9" => :mavericks
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  terraform_deps = %w[
    github.com/mitchellh/gox 770c39f64e66797aa46b70ea953ff57d41658e40
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/Azure/azure-sdk-for-go bc148c2c7ee5113748941126b465e4ad6eee8e1d
    github.com/aws/aws-sdk-go bc2c5714d312337494394909e7cc3a19a2e68530
    github.com/cenkalti/backoff 4dc77674aceaabba2c7e3da25d4c823edfb73f99
    github.com/davecgh/go-spew 5215b55f46b2b919f50a1df0eaa5886afe4e3b3d
    gopkg.in/yaml.v2 f7716cbe52baa25d2e9b0d0da546fcf909fc16b4
    github.com/golang/protobuf 45bba206dd5270d96bac4942dcfe515726613249
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git", :revision => "977844c7af2aa555048a19d28e9fe6c392e7b8e9"
  end

  go_resource "google.golang.org/grpc" do
    url "https://github.com/grpc/grpc-go.git", :revision => "5d64098b94ee9dbbea8ddc130208696bcd199ba4"
  end

  def install
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by terraform, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    terrapath = buildpath/"src/github.com/hashicorp/terraform"
    terrapath.install Dir["*"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/golang.org/x/tools/cmd/stringer" do
      system "go", "build"
      buildpath.install "stringer"
    end

    cd terrapath do
      terraform_files = `go list ./...`.lines.map { |f| f.strip unless f.include? "/vendor/" }.compact
      # v0.6.12 - source contains tests which fail if these environment variables are set locally.
      ENV.delete "AWS_ACCESS_KEY"
      ENV.delete "AWS_SECRET_KEY"
      system "go", "test", *terraform_files

      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox",
        "-arch", arch,
        "-os", "darwin",
        "-output", "bin/terraform-{{.Dir}}", *terraform_files
      bin.install "bin/terraform-terraform" => "terraform"
      bin.install Dir["bin/*"]
      zsh_completion.install "contrib/zsh-completion/_terraform"
    end
  end

  test do
    minimal = testpath/"minimal.tf"
    minimal.write <<-EOS.undent
      variable "aws_region" {
          default = "us-west-2"
      }

      variable "aws_amis" {
          default = {
              eu-west-1 = "ami-b1cf19c6"
              us-east-1 = "ami-de7ab6b6"
              us-west-1 = "ami-3f75767a"
              us-west-2 = "ami-21f78e11"
          }
      }

      # Specify the provider and access details
      provider "aws" {
          access_key = "this_is_a_fake_access"
          secret_key = "this_is_a_fake_secret"
          region = "${var.aws_region}"
      }

      resource "aws_instance" "web" {
        instance_type = "m1.small"
        ami = "${lookup(var.aws_amis, var.aws_region)}"
        count = 4
      }
    EOS
    system "#{bin}/terraform", "graph", testpath
  end
end
