require "formula"
require "language/go"

class Terraform < Formula
  homepage "http://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.2.1.tar.gz"
  sha1 "f2772e785bfc2e409a3578c41557ba1988aa3153"

  bottle do
    sha1 "94ae5dcbc41ad630b9a5ebe85f814a7c107a122b" => :mavericks
    sha1 "17ba9f29cb8b7808c294dbb019c2056ef834088e" => :mountain_lion
    sha1 "24a307812d75adbbc764a80972723fc68acaae0a" => :lion
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git", :tag => "v0.3.0"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git", :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git", :revision => "a0a5d2873ec34d649ced122e53b180c27474f3a3"
  end

  go_resource "github.com/mitchellh/copystructure" do
    url "https://github.com/mitchellh/copystructure.git", :revision => "d8968bce41ab42f33aeb143afa95e331cb1ba886"
  end

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git", :revision => "9989d7067f58812d814f5a837c5cbdd31799b694"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git", :revision => "740c764bc6149d3f1806231418adb9f52c11bcbf"
  end

  go_resource "github.com/mitchellh/goamz" do
    url "https://github.com/mitchellh/goamz.git", :revision => "9cad7da945e699385c1a3e115aa255211921c9bb"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git", :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/pearkes/cloudflare" do
    url "https://github.com/pearkes/cloudflare.git", :revision => "79e8a91a6e873a40d645ac9f03f7cdcbfdb8103a"
  end

  go_resource "github.com/armon/consul-api" do
    url "https://github.com/armon/consul-api.git", :revision => "045662de1042be0662fe4a1e21b57c8f7669261a"
  end

  go_resource "github.com/pearkes/digitalocean" do
    url "https://github.com/pearkes/digitalocean.git", :revision => "0c9e1876f4db62d725158402ab5158db334d491f"
  end

  go_resource "github.com/pearkes/dnsimple" do
    url "https://github.com/pearkes/dnsimple.git", :revision => "b01a0dd175142d0beafd32d7de2b9342d34cc4c0"
  end

  go_resource "github.com/cyberdelia/heroku-go" do
    url "https://github.com/cyberdelia/heroku-go.git", :revision => "8cf5a2245af00170a36c9b2aaa504a97328659bb"
  end

  go_resource "github.com/pearkes/mailgun" do
    url "https://github.com/pearkes/mailgun.git", :revision => "5b02e7e9ffee9869f81393e80db138f6ff726260"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "0af1630672c20c57b4f10c2afba2264516562918"
  end

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git", :revision => "f092b4f207b6e5cce0569056fba9e1a2735cb6cf"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git", :revision => "bfacda5ba006a32b10ddfe2abad56c11661573eb"
  end

  go_resource "github.com/mitchellh/colorstring" do
    url "https://github.com/mitchellh/colorstring.git", :revision => "15fc698eaae194ff160846daf77922a45b9290a7"
  end

  go_resource "github.com/mitchellh/osext" do
    url "https://github.com/mitchellh/osext.git", :revision => "0dd3f918b21bec95ace9dc86c7e70266cfc5c702"
  end

  go_resource "github.com/mitchellh/panicwrap" do
    url "https://github.com/mitchellh/panicwrap.git", :revision => "45cbfd3bae250c7676c077fb275be1a2968e066a"
  end

  go_resource "github.com/mitchellh/prefixedio" do
    url "https://github.com/mitchellh/prefixedio.git", :revision => "64119910ab902e336f308a1ed751a3721ba24c23"
  end

  go_resource "code.google.com/p/goauth2" do
    url "https://code.google.com/p/goauth2/", :revision => "afe77d958c70",
      :using => :hg
  end

  go_resource "code.google.com/p/google-api-go-client" do
    url "https://code.google.com/p/google-api-go-client/", :revision => "e1c259484b49",
      :using => :hg
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid/", :revision => "7dda39b2e7d5",
      :using => :hg
  end

  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto/", :revision => "00a7d3b31bba",
      :using => :hg
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

    cd terrapath do
      system "make", "test"

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
    system "#{bin}/terraform", "plan", testpath
  end
end
