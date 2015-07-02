require "formula"
require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.0.tar.gz"
  sha256 "444e342f2404679045a5f2a6b8c6de2f1226e2d80c3bd5d3db20b5f3b9592f18"

  bottle do
    cellar :any
    sha256 "ca01644d5769f3fad1afdae3d7fd14c21d46a8c8718489d764a7152a4b5cb451" => :yosemite
    sha256 "1357d87bcd1076a0788230899fe0b64f14fc508c05375164c7c7faa7fb7149a1" => :mavericks
    sha256 "f0a35f02200f9ef904b7c67af06773b52ed1125d9277364ef7ec894a9b413e26" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/awslabs/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "b1024787e030774e84f3aa6995f2c3891283b4a0"
  end

  terraform_deps = %w[
    github.com/Azure/azure-sdk-for-go 91977650587a7bc48318c0430649d7fea886f111
    github.com/Azure/go-pkcs12 a635c0684cd517745ca5c9552a312627791d5ba0
    github.com/armon/circbuf f092b4f207b6e5cce0569056fba9e1a2735cb6cf
    github.com/aws/aws-sdk-go b1024787e030774e84f3aa6995f2c3891283b4a0
    github.com/cyberdelia/heroku-go 594d483b9b6a8ddc7cd2f1e3e7d1de92fa2de665
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient bacc91d0d732390df132783988dc17c611881047
    github.com/hashicorp/atlas-go 1b403631cd2d44764a68a9549874213cf95b285e
    github.com/hashicorp/consul 9cb55266e7df62f2c3fd393503331140a05bfeb6
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint 88326f6851319068e7b34981032128c0b1a6524d
    github.com/hashicorp/go-multierror 56912fb08d85084aa318edcf2bba735b97cf35c5
    github.com/hashicorp/go-version 999359b6b7a041ce16e695d51e92145b83f01087
    github.com/hashicorp/hcl 54864211433d45cb780682431585b3e573b49e4a
    github.com/hashicorp/yamux b2e55852ddaf823a85c67f798080eb7d08acd71d
    github.com/imdario/mergo 61a52852277811e93e06d28e0d0c396284a7730b
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm 132339029dfa67fd39ff8edeed2af78f2cca4fbb
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mitchellh/cli 8102d0ed5ea2709ade1243798785888175f6e415
    github.com/mitchellh/colorstring 61164e49940b423ba1f12ddbdf01632ac793e5e9
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir 1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4
    github.com/mitchellh/gox a5a468f84d74eb51ece602cb113edeb37167912f
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/mapstructure 2caf8efc93669b6c43e0441cdc6aed17546c96f3
    github.com/mitchellh/osext 0dd3f918b21bec95ace9dc86c7e70266cfc5c702
    github.com/mitchellh/packer 3239d157c16ad1612d652940b2da2981614c97e4
    github.com/mitchellh/panicwrap 45cbfd3bae250c7676c077fb275be1a2968e066a
    github.com/mitchellh/prefixedio 89d9b535996bf0a185f85b59578f2e245f9e1724
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 743b1afe5ee3f6d5ba71a0d50673fa0ba2123d6b
    github.com/pearkes/cloudflare 19e280b056f3742e535ea12ae92a37ea7767ea82
    github.com/pearkes/digitalocean e966f00c2d9de5743e87697ab77c7278f5998914
    github.com/pearkes/dnsimple 2a807d118c9e52e94819f414a6ec0293b45cad01
    github.com/pearkes/mailgun 5b02e7e9ffee9869f81393e80db138f6ff726260
    github.com/rackspace/gophercloud f956c6c6c0c55844eff4b153b5071ef6e3ab4ab4
    github.com/satori/go.uuid afe1e2ddf0f05b7c29d388a3f8e76cb15c2231ca
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/vaughan0/go-ini a98ad7ee00ec53921f08832bc06ecf7fd600e6a1
    github.com/xanzy/go-cloudstack 4d162c3e1955cd12235a8f0abaa95fe0bbf08c63
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
    crypto cc04154d65fb9296747569b107cfd05380b1ea3e
    net d9558e5c97f85372afee28cf2b6059d7d3818919
    oauth2 b5adcc2dcdf009d0391547edc6ecbaff889f5bb9
    tools 997b3545fd86c3a2d8e5fe6366174d7786e71278
    ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "a09229c13c2f13bbdedf7b31b506cad4c83ef3bf"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "15c0736a396d4a63e96b29802364d721ed0a33d5"
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
