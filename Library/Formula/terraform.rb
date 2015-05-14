require "formula"
require "language/go"

class Terraform < Formula
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.5.0.tar.gz"
  sha1 "6befb71e505efa246cb48e9ece829b93fea367fb"

  bottle do
    cellar :any
    sha256 "ebf80d6dadaac89c0492030a44ae6ae3c386754fe467cf705c01a0334cded4ef" => :yosemite
    sha256 "5816bc8ad31ee155e9783b948f297bca86096189f65c13b3e66ee3c138d29e45" => :mavericks
    sha256 "7c2ef7e1bb3ae1da851d05d0d67c7d86f155b0fc4f6b8b03af844063e8c891d3" => :mountain_lion
  end

  depends_on "go" => :build

  terraform_deps = %w[
github.com/Sirupsen/logrus aaf92c95712104318fc35409745f1533aa5ff327
github.com/armon/circbuf f092b4f207b6e5cce0569056fba9e1a2735cb6cf
github.com/awslabs/aws-sdk-go bba8ba311b61785d4a866fe5c110737d9bf8b764
github.com/cyberdelia/heroku-go 594d483b9b6a8ddc7cd2f1e3e7d1de92fa2de665
github.com/docker/docker af9dac9627e7b04a803df152cc24f0db073ea17a
github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
github.com/fsouza/go-dockerclient 0ba7f0a32981ca4c1043c245017eb099708695ef
github.com/hashicorp/atlas-go 6a87d5f443991e9916104392cd5fc77678843e1d
github.com/hashicorp/aws-sdk-go e6ea0192eee4640f32ec73c0cbb71f63e4f2b65a
github.com/hashicorp/consul 5d0f83d73db83536ccb69725fe516753b96a2081
github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
github.com/hashicorp/go-checkpoint 88326f6851319068e7b34981032128c0b1a6524d
github.com/hashicorp/go-multierror fcdddc395df1ddf4247c69bd436e84cfa0733f7e
github.com/hashicorp/go-version bb92dddfa9792e738a631f04ada52858a139bcf7
github.com/hashicorp/hcl 513e04c400ee2e81e97f5e011c08fb42c6f69b84
github.com/hashicorp/yamux b2e55852ddaf823a85c67f798080eb7d08acd71d
github.com/imdario/mergo 2fcac9923693d66dc0e03988a31b21da05cdea84
github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
github.com/masterzen/winrm 813d86ee814a2d07cb1153d0c1cb922f3f8239b7
github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
github.com/mitchellh/cli 6cc8bc522243675a2882b81662b0b0d2e04b99c9
github.com/mitchellh/colorstring 61164e49940b423ba1f12ddbdf01632ac793e5e9
github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
github.com/mitchellh/go-homedir 1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4
github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
github.com/mitchellh/gox e8e6fd4fe12510cc46893dff18c5188a6a6dc549
github.com/mitchellh/iochan b584a329b193e206025682ae6c10cdbe03b0cd77
github.com/mitchellh/mapstructure 442e588f213303bec7936deba67901f8fc8f18b1
github.com/mitchellh/osext 0dd3f918b21bec95ace9dc86c7e70266cfc5c702
github.com/mitchellh/packer c8b3dfff5fa8470f7d639c3e6b09f15ff09fa7c2
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

  %w[crypto 24ffb5feb3312a39054178a4b0a4554fc2201248
     net a8c61998a557a37435f719980da368469c10bfed
     oauth2 ec6d5d770f531108a6464462b2201b74fcd09314
     tools 96f6cfbb921ad6d191c67d09a6d4c4fd056403ae].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "0297be7525f49a3c3f4b5e0a9c92f46fe2319b36"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "332d04a26dd158633a030756753b5a02a8247a0b"
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
