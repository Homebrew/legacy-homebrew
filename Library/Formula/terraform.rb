require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.4.tar.gz"
  sha256 "5826ceaede319e4814e9e0f909dcd6d210899b940492f1544ce3dd3e000cfa22"

  bottle do
    cellar :any_skip_relocation
    sha256 "98187bc1e45d960663913f94bb99ed63698327c1a3b9387387c807bac15afa71" => :el_capitan
    sha256 "97b4e4871b6d445a2f9768c88df84350fb53b9bfdfab942aa278b0cb378ea532" => :yosemite
    sha256 "efa666c80744fb134c2141774ce86a2694a0809e0be38be68bdbc16509e3c330" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/Azure/azure-sdk-for-go 3dcabb61c225af4013db7af20d4fe430fd09e311
    github.com/apparentlymart/go-rundeck-api cddcfbabbe903e9c8df35ff9569dbb8d67789200
    github.com/armon/circbuf bbbad097214e2918d8543d5201d12bfd7bca254d
    github.com/aws/aws-sdk-go 308eaa65c0ddf03c701d511b7d73b3f3620452a1
    github.com/awslabs/aws-sdk-go 308eaa65c0ddf03c701d511b7d73b3f3620452a1
    github.com/cyberdelia/heroku-go 8344c6a3e281a99a693f5b71186249a8620eeb6b
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient 09604abc82243886001c3f56fd709d4ba603cead
    github.com/hashicorp/atlas-go 85a782d724b87fcd19db1c4aef9d5337a9bb7a0f
    github.com/hashicorp/consul 5d9530d7def3be989ba141382f1b9d82583418f4
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint 528ab62f37fa83d4360e8ab2b2c425d6692ef533
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-version 2b9865f60ce11e527bd1255ba82036d465570aa3
    github.com/hashicorp/hcl 4de51957ef8d4aba6e285ddfc587633bbfc7c0e8
    github.com/hashicorp/logutils 0dc08b1671f34c4250ce212759ebd880f743d883
    github.com/hashicorp/yamux ddcd0a6ec7c55e29f235e27935bf98d302281bd3
    github.com/imdario/mergo 61a52852277811e93e06d28e0d0c396284a7730b
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm b280be362a0c6af26fbaaa055924fb9c4830b006
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mitchellh/cli 8102d0ed5ea2709ade1243798785888175f6e415
    github.com/mitchellh/colorstring 8631ce90f28644f54aeedcb3e389a85174e067d1
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir df55a15e5ce646808815381b3db47a8c66ea62f4
    github.com/mitchellh/gox a5a468f84d74eb51ece602cb113edeb37167912f
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/osext 0dd3f918b21bec95ace9dc86c7e70266cfc5c702
    github.com/mitchellh/packer 88386bc9db1c850306e5c3737f14bef3a2c4050d
    github.com/mitchellh/panicwrap 1655d88c8ff7495ae9d2c19fd8f445f4657e22b0
    github.com/mitchellh/prefixedio 89d9b535996bf0a185f85b59578f2e245f9e1724
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 743b1afe5ee3f6d5ba71a0d50673fa0ba2123d6b
    github.com/packethost/packngo 496f5c8895c06505fae527830a9e554dc65325f4
    github.com/pborman/uuid cccd189d45f7ac3368a0d127efb7f4d08ae0b655
    github.com/pearkes/cloudflare 19e280b056f3742e535ea12ae92a37ea7767ea82
    github.com/pearkes/digitalocean e966f00c2d9de5743e87697ab77c7278f5998914
    github.com/pearkes/dnsimple 2a807d118c9e52e94819f414a6ec0293b45cad01
    github.com/pearkes/mailgun 5b02e7e9ffee9869f81393e80db138f6ff726260
    github.com/rackspace/gophercloud 8d032cb1e835a0018269de3d6b53bb24fc77a8c0
    github.com/satori/go.uuid 08f0718b61e95ddba0ade3346725fe0e4bf28ca6
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/vaughan0/go-ini a98ad7ee00ec53921f08832bc06ecf7fd600e6a1
    github.com/vmware/govmomi 603786323c18c13dd8b3da3d4f86b1dce4adf126
    github.com/xanzy/go-cloudstack 0e6e56fc0db3f48f060273f2e2ffe5d8d41b0112
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  %w[
    crypto c8b9e6388ef638d5a8a9d865c634befdc46a6784
    net 21c3935a8fc0f954d03e6b8a560c9600ffee38d2
    oauth2 ef4eca6b097fad7cec79afcc278d213a6de1c960
    tools 4f50f44d7a3206e9e28b984e023efce2a4a75369
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "e2903ca9e33d6cbaedda541d96996219056e8214"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "4bea1598a0936d6d116506b59a8e1aa962b585c3"
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
    system "#{bin}/terraform", "graph", testpath
  end
end
