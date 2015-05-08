require "formula"
require "language/go"

class Terraform < Formula
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.5.0.tar.gz"
  sha1 "6befb71e505efa246cb48e9ece829b93fea367fb"

  bottle do
    cellar :any
  end

  depends_on "go" => :build

  terraform_deps = %w[
github.com/Sirupsen/logrus
github.com/armon/circbuf
github.com/awslabs/aws-sdk-go
github.com/cyberdelia/heroku-go
github.com/docker/docker
github.com/dylanmei/iso8601
github.com/dylanmei/winrmtest
github.com/fsouza/go-dockerclient
github.com/hashicorp/atlas-go
github.com/hashicorp/aws-sdk-go
github.com/hashicorp/consul
github.com/hashicorp/errwrap
github.com/hashicorp/go-checkpoint
github.com/hashicorp/go-multierror
github.com/hashicorp/go-version
github.com/hashicorp/hcl
github.com/hashicorp/yamux
github.com/imdario/mergo
github.com/masterzen/simplexml
github.com/masterzen/winrm
github.com/masterzen/xmlpath
github.com/mitchellh/cli
github.com/mitchellh/colorstring
github.com/mitchellh/copystructure
github.com/mitchellh/gox
github.com/mitchellh/go-homedir
github.com/mitchellh/iochan
github.com/mitchellh/go-linereader
github.com/mitchellh/mapstructure
github.com/mitchellh/osext
github.com/mitchellh/packer
github.com/mitchellh/panicwrap
github.com/mitchellh/prefixedio
github.com/mitchellh/reflectwalk
github.com/nu7hatch/gouuid
github.com/packer-community/winrmcp
github.com/pearkes/cloudflare
github.com/pearkes/digitalocean
github.com/pearkes/dnsimple
github.com/pearkes/mailgun
github.com/rackspace/gophercloud
github.com/satori/go.uuid
github.com/soniah/dnsmadeeasy
github.com/vaughan0/go-ini
github.com/xanzy/go-cloudstack
  ]

  terraform_deps.each do |x|
    go_resource x do
      url "https://#{x}.git"
    end
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid", using: :hg
  end

  %w[crypto net oauth2 tools].each do |x|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git"
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git"
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
      system "go", "test", "./..."

      mkdir "bin"
      arch = MacOS.prefer_64_bit? ? "amd64" : "386"
      system "gox", "-arch", arch,
        "-os", "darwin",
        "-output", "bin/terraform-{{.Dir}}",
        "./..."
      bin.install "bin/terraform-terraform" => "terraform"
      bin.install Dir["bin/*"]
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
    system "#{bin}/terraform", "plan", "-var", "aws.region=us-west-2", testpath
  end
end 
