require "formula"
require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.5.3.tar.gz"
  sha256 "be71d430df5b28deaff815ee775bbb4d8e240b145450d6c027baa6ef0860ca94"

  bottle do
    cellar :any
    sha256 "ca01644d5769f3fad1afdae3d7fd14c21d46a8c8718489d764a7152a4b5cb451" => :yosemite
    sha256 "1357d87bcd1076a0788230899fe0b64f14fc508c05375164c7c7faa7fb7149a1" => :mavericks
    sha256 "f0a35f02200f9ef904b7c67af06773b52ed1125d9277364ef7ec894a9b413e26" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/awslabs/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "43d7c58d0a71c01d98b7881cb9f90047f04f4acd"
  end

  terraform_deps = %w[
    github.com/Sirupsen/logrus 52919f182f9c314f8a38c5afe96506f73d02b4b2
    github.com/armon/circbuf f092b4f207b6e5cce0569056fba9e1a2735cb6cf
    github.com/cyberdelia/heroku-go 594d483b9b6a8ddc7cd2f1e3e7d1de92fa2de665
    github.com/docker/docker 42cfc95549728014811cc9aa2c5b07bdf5553a54
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient f90594a4da6a7cbdaedd29ee5495ddd6b39fe5d3
    github.com/hashicorp/atlas-go 6a87d5f443991e9916104392cd5fc77678843e1d
    github.com/hashicorp/aws-sdk-go e6ea0192eee4640f32ec73c0cbb71f63e4f2b65a
    github.com/hashicorp/consul 9417fd37686241d65918208874a7faa4d0cd92d2
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint 88326f6851319068e7b34981032128c0b1a6524d
    github.com/hashicorp/go-multierror fcdddc395df1ddf4247c69bd436e84cfa0733f7e
    github.com/hashicorp/go-version 999359b6b7a041ce16e695d51e92145b83f01087
    github.com/hashicorp/hcl 513e04c400ee2e81e97f5e011c08fb42c6f69b84
    github.com/hashicorp/yamux b2e55852ddaf823a85c67f798080eb7d08acd71d
    github.com/imdario/mergo 2fcac9923693d66dc0e03988a31b21da05cdea84
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm 132339029dfa67fd39ff8edeed2af78f2cca4fbb
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mitchellh/cli 6cc8bc522243675a2882b81662b0b0d2e04b99c9
    github.com/mitchellh/colorstring 61164e49940b423ba1f12ddbdf01632ac793e5e9
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir 1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4
    github.com/mitchellh/gox e8e6fd4fe12510cc46893dff18c5188a6a6dc549
    github.com/mitchellh/iochan b584a329b193e206025682ae6c10cdbe03b0cd77
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/mapstructure 442e588f213303bec7936deba67901f8fc8f18b1
    github.com/mitchellh/osext 0dd3f918b21bec95ace9dc86c7e70266cfc5c702
    github.com/mitchellh/packer 350a5f8cad6a0e4c2b24c3049a84c4f294416e16
    github.com/mitchellh/panicwrap 45cbfd3bae250c7676c077fb275be1a2968e066a
    github.com/mitchellh/prefixedio 89d9b535996bf0a185f85b59578f2e245f9e1724
    github.com/mitchellh/reflectwalk 242be0c275dedfba00a616563e6db75ab8f279ec
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 650a91d1da6dc3fefa8f052289ffce648924a304
    github.com/pearkes/cloudflare 19e280b056f3742e535ea12ae92a37ea7767ea82
    github.com/pearkes/digitalocean e966f00c2d9de5743e87697ab77c7278f5998914
    github.com/pearkes/dnsimple 1e0c2b0eb33ca7b5632a130d6d34376a1ea46c84
    github.com/pearkes/mailgun 5b02e7e9ffee9869f81393e80db138f6ff726260
    github.com/rackspace/gophercloud 9ad4137a6b3e786b9c1e161b8d354b44482ab6d7
    github.com/satori/go.uuid 7c7f2020c4c9491594b85767967f4619c2fa75f9
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/vaughan0/go-ini a98ad7ee00ec53921f08832bc06ecf7fd600e6a1
    github.com/xanzy/go-cloudstack f73f6ff1b843dbdac0a01da7b7f39883adfe2bdb
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid", :using => :hg,
      :revision => "35bc42037350"
  end

  %w[
    crypto 4d48e5fa3d62b5e6e71260571bf76c767198ca02
    net 5aa7325eaa14d7ed4b520f40d58adf2834c8de01
    oauth2 f98d0160877ab4712b906626425ed8b0b320907c
    tools 96f6cfbb921ad6d191c67d09a6d4c4fd056403ae
    ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "d4ab0b854f8606d689612515c3d18bd3b19d7e70"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "2f1f05fa5ef92aac6109243f351e01ae3e033402"
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
