require "formula"
require "language/go"

class Terraform < Formula
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.4.2.tar.gz"
  sha1 "4d83a6db2879d277ffd662d1c0dcaad1da0e75e9"

  bottle do
    cellar :any
    sha256 "ca67d033cf2900ffaa3deb25623dd73cbd6e126d7b78c0388c32703db84aa8b8" => :yosemite
    sha256 "03e5765e051992610134cc4bf289c03ef6eb1a8355b25bda9544360aabd59f9e" => :mavericks
    sha256 "893f7bcadd569adfc58e47acb72091daa4bd028cea770b0d638a8aee1488c7f5" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git", :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git", :revision => "e8e6fd4fe12510cc46893dff18c5188a6a6dc549"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git", :revision => "2a105dc4ba99792ac380f48d154af4e10b822846"
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid", :revision => "35bc42037350f0078e3c974c6ea690f1926603ab", :using => :hg
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git", :revision => "c97f5f9979a8582f3ab72873a51979619801248b"
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git", :revision => "2f6114897375589857c508d7392e55d5e7580db8"
  end

  go_resource "github.com/Sirupsen/logrus" do
    url "https://github.com/Sirupsen/logrus.git", :revision => "cdd90c38c6e3718c731b555b9c3ed1becebec3ba"
  end

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git", :revision => "f092b4f207b6e5cce0569056fba9e1a2735cb6cf"
  end

  go_resource "github.com/awslabs/aws-sdk-go" do
    url "https://github.com/awslabs/aws-sdk-go.git", :revision => "a79c7d95c012010822e27aaa5551927f5e8a6ab6"
  end

  go_resource "github.com/cyberdelia/heroku-go" do
    url "https://github.com/cyberdelia/heroku-go.git", :revision => "594d483b9b6a8ddc7cd2f1e3e7d1de92fa2de665"
  end

  go_resource "github.com/docker/docker" do
    url "https://github.com/docker/docker.git", :revision => "dd4389fb19e442d386c3106545f04387c08e6a91"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git", :revision => "fb0e9fb80f074795d7c11eba700eb33058b14bfb"
  end

  go_resource "github.com/hashicorp/atlas-go" do
    url "https://github.com/hashicorp/atlas-go.git", :revision => "90aad8fc22a107db14dd80efdc131a197f7234e6"
  end

  go_resource "github.com/hashicorp/aws-sdk-go" do
    url "https://github.com/hashicorp/aws-sdk-go.git", :revision => "1d5c8f6b881ab3e2e0c3e737886732bbfd1ced27"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git", :revision => "e5797d9a86b025d009809199146747384ad34db7"
  end

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git", :revision => "7554cd9344cec97297fa6649b055a8c98c2a1e55"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git", :revision => "88326f6851319068e7b34981032128c0b1a6524d"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git", :revision => "fcdddc395df1ddf4247c69bd436e84cfa0733f7e"
  end

  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git", :revision => "bb92dddfa9792e738a631f04ada52858a139bcf7"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git", :revision => "513e04c400ee2e81e97f5e011c08fb42c6f69b84"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git", :revision => "b2e55852ddaf823a85c67f798080eb7d08acd71d"
  end

  go_resource "github.com/imdario/mergo" do
    url "https://github.com/imdario/mergo.git", :revision => "2fcac9923693d66dc0e03988a31b21da05cdea84"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git", :revision => "afc399c273e70173826fb6f518a48edff23fe897"
  end

  go_resource "github.com/mitchellh/colorstring" do
    url "https://github.com/mitchellh/colorstring.git", :revision => "61164e49940b423ba1f12ddbdf01632ac793e5e9"
  end

  go_resource "github.com/mitchellh/copystructure" do
    url "https://github.com/mitchellh/copystructure.git", :revision => "c101d94abf8cd5c6213c8300d0aed6368f2d6ede"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "7d2d8c8a4e078ce3c58736ab521a40b37a504c52"
  end

  go_resource "github.com/mitchellh/go-linereader" do
    url "https://github.com/mitchellh/go-linereader.git", :revision => "07bab5fdd9580500aea6ada0e09df4aa28e68abd"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git", :revision => "442e588f213303bec7936deba67901f8fc8f18b1"
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

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git", :revision => "9cdd861463675960a0a0083a7e2023e7b0c994d7"
  end

  go_resource "github.com/pearkes/cloudflare" do
    url "https://github.com/pearkes/cloudflare.git", :revision => "19e280b056f3742e535ea12ae92a37ea7767ea82"
  end

  go_resource "github.com/pearkes/digitalocean" do
    url "https://github.com/pearkes/digitalocean.git", :revision => "e966f00c2d9de5743e87697ab77c7278f5998914"
  end

  go_resource "github.com/pearkes/dnsimple" do
    url "https://github.com/pearkes/dnsimple.git", :revision => "1e0c2b0eb33ca7b5632a130d6d34376a1ea46c84"
  end

  go_resource "github.com/pearkes/mailgun" do
    url "https://github.com/pearkes/mailgun.git", :revision => "5b02e7e9ffee9869f81393e80db138f6ff726260"
  end

  go_resource "github.com/rackspace/gophercloud" do
    url "https://github.com/rackspace/gophercloud.git", :revision => "ce0f487f6747ab43c4e4404722df25349385bebd"
  end

  go_resource "github.com/soniah/dnsmadeeasy" do
    url "https://github.com/soniah/dnsmadeeasy.git", :revision => "5578a8c15e33958c61cf7db720b6181af65f4a9e"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git", :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/xanzy/go-cloudstack" do
    url "https://github.com/xanzy/go-cloudstack.git", :revision => "f73f6ff1b843dbdac0a01da7b7f39883adfe2bdb"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git", :revision => "c57d4a71915a248dbad846d60825145062b4c18e"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "84ba27dd5b2d8135e9da1395277f2c9333a2ffda"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git", :revision => "ce5ea7da934b76b1066c527632359e2b8f65db97"
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
