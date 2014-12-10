require "formula"
require "language/go"

class Terraform < Formula
  homepage "http://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.3.5.tar.gz"
  sha1 "2c53b217faedbcffcdf5fb78f1ab585f36e5f21f"

  bottle do
    sha1 "71b4d2cf75a292ef44f6fe8c688d3396275ff7bb" => :yosemite
    sha1 "2a9b71e0a58d2b07eedd33eb43ec11ba6e859996" => :mavericks
    sha1 "2a5dcd44de95b2f95cd0bb0264398d9a71798990" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git", :tag => "v0.3.0"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git", :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git", :revision => "25719dbfedc20ce21c23dadb25983fad4694dcf8"
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
    url "https://github.com/mitchellh/goamz.git", :revision => "ab653226ea8718749271e08212506d411714e865"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git", :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/pearkes/cloudflare" do
    url "https://github.com/pearkes/cloudflare.git", :revision => "79e8a91a6e873a40d645ac9f03f7cdcbfdb8103a"
  end

  go_resource "github.com/armon/consul-api" do
    url "https://github.com/armon/consul-api.git", :revision => "115162c46303047d9cefb2a953eeb643d4624a3e"
  end

  go_resource "github.com/pearkes/digitalocean" do
    url "https://github.com/pearkes/digitalocean.git", :revision => "454ebf8720a34e077ebe62c7cd5a248cbf7ca8ff"
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
    url "https://github.com/mitchellh/go-homedir.git", :revision => "7d2d8c8a4e078ce3c58736ab521a40b37a504c52"
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
    url "https://github.com/mitchellh/prefixedio.git", :revision => "89d9b535996bf0a185f85b59578f2e245f9e1724"
  end

  go_resource "github.com/mitchellh/go-linereader" do
    url "https://github.com/mitchellh/go-linereader.git", :revision => "07bab5fdd9580500aea6ada0e09df4aa28e68abd"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git", :revision => "9feabe6854fadca1abec9cd3bd2a613fe9a34000"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git", :revision => "89ef2a697dd8cdb4623097d5bb9acdb19a470767"
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

  go_resource "github.com/hashicorp/atlas-go" do
    url "https://github.com/hashicorp/atlas-go.git", :revision => "072814b5d05e34466c6c0fdd62cdecf184dc3521"
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
      # Clear ATLAS_TOKEN env var to not run atlas acceptance tests
      # that would require an active atlas account
      system "make", "test", "ATLAS_TOKEN="

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
