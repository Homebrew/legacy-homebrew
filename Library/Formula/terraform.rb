require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.7.tar.gz"
  sha256 "20a1e82dba833abb6732b5c712930cdbc4feaf5b6572e3c3463f725515372e81"

  bottle do
    cellar :any_skip_relocation
    sha256 "2d821a58fb0976d94e5fda2264e538da292bc8ac0c7da55d230604de2d284182" => :el_capitan
    sha256 "06ac794a23773aacccde38bd5ac3bef6e313b99e7fc9934957e2dae1d97a61c2" => :yosemite
    sha256 "5169f384a5c17f76fcb591ffd70c614399cfc01d77fd567b71a8a4b7c5cdb6a3" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/apparentlymart/go-cidr a3ebdb999b831ecb6ab8a226e31b07b2b9061c47
    github.com/apparentlymart/go-rundeck-api cddcfbabbe903e9c8df35ff9569dbb8d67789200
    github.com/armon/circbuf bbbad097214e2918d8543d5201d12bfd7bca254d
    github.com/aws/aws-sdk-go 328e030f73f66922cb9c1357de794ee1bf0ca2b5
    github.com/Azure/azure-sdk-for-go 3b480eaaf6b4236d43a3c06cba969da6f53c8b66
    github.com/coreos/etcd d435d443bb7659a2ff400c185fe5c6eea9fc81ed
    github.com/cyberdelia/heroku-go 8344c6a3e281a99a693f5b71186249a8620eeb6b
    github.com/digitalocean/godo 4ac7bea157899131b3f94085219a4c650e19f696
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient 0f5764b4d2f5b8928a05db1226a508817a9a01dd
    github.com/go-ini/ini 2e44421e256d82ebbf3d4d4fcabe8930b905eff3
    github.com/google/go-querystring 2a60fc2ba6c19de80291203597d752e9ba58e4c0
    github.com/hashicorp/atlas-go 6c9afe8bb88099b424db07dea18f434371de8199
    github.com/hashicorp/consul 4d42ff66e304e3f09eaae621ea4b0792e435064a
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint e4b2dc34c0f698ee04750bf2035d8b9384233e1b
    github.com/hashicorp/go-cleanhttp 5df5ddc69534f1a4697289f1dca2193fbb40213f
    github.com/hashicorp/go-getter c5e245982bdb4708f89578c8e0054d82b5197401
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-version 2b9865f60ce11e527bd1255ba82036d465570aa3
    github.com/hashicorp/hcl 1688f22977e3b0bbdf1aaa5e2528cf10c2e93e78
    github.com/hashicorp/logutils 0dc08b1671f34c4250ce212759ebd880f743d883
    github.com/hashicorp/serf a72c0453da2ba628a013e98bf323a76be4aa1443
    github.com/hashicorp/yamux ddcd0a6ec7c55e29f235e27935bf98d302281bd3
    github.com/imdario/mergo bb554f9fd6ee4cd190eef868de608ced813aeda1
    github.com/jmespath/go-jmespath 3433f3ea46d9f8019119e7dd41274e112a2359a9
    github.com/kardianos/osext 345163ffe35aa66560a4cd7dddf00f3ae21c9fda
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm 06208eee5d76e4a422494e25629cefec42b9b3ac
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mitchellh/cli 8102d0ed5ea2709ade1243798785888175f6e415
    github.com/mitchellh/colorstring 8631ce90f28644f54aeedcb3e389a85174e067d1
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir d682a8f0cf139663a984ff12528da460ca963de9
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/gox 770c39f64e66797aa46b70ea953ff57d41658e40
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/osext 5e2d6d41470f99c881826dedd8c526728b783c9c
    github.com/mitchellh/packer 25108c8d13912434d0f32faaf1ea13cdc537b21e
    github.com/mitchellh/panicwrap 89dc8accc8fec9dfa9b8e1ffdd6793265253de16
    github.com/mitchellh/prefixedio 89d9b535996bf0a185f85b59578f2e245f9e1724
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    github.com/nesv/go-dynect 841842b16b39cf2b5007278956976d7d909bd98b
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 3d184cea22ee1c41ec1697e0d830ff0c78f7ea97
    github.com/packethost/packngo f03d7dc788a8b57b62d301ccb98c950c325756f8
    github.com/pborman/uuid cccd189d45f7ac3368a0d127efb7f4d08ae0b655
    github.com/pearkes/cloudflare 3d4cd12a4c3a7fc29b338b774f7f8b7e3d5afc2e
    github.com/pearkes/dnsimple 78996265f576c7580ff75d0cb2c606a61883ceb8
    github.com/pearkes/mailgun b88605989c4141d22a6d874f78800399e5bb7ac2
    github.com/rackspace/gophercloud 761cff8afb6a8e7f42c5554a90dae72f341bb481
    github.com/satori/go.uuid d41af8bb6a7704f00bc3b7cba9355ae6a5a80048
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/tent/http-link-go ac974c61c2f990f4115b119354b5e0b47550e888
    github.com/ugorji/go ea9cd21fa0bc41ee4bdd50ac7ed8cbc7ea2ed960
    github.com/vmware/govmomi daf6c9cce2d14cdd05fc38319ad58a5e0d3f7654
    github.com/xanzy/go-cloudstack 0e6e56fc0db3f48f060273f2e2ffe5d8d41b0112
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  %w[
    crypto beef0f4390813b96e8e68fd78570396d0f4751fc
    net 4f2fc6c1e69d41baf187332ee08fbd2b296f21ed
    oauth2 442624c9ec9243441e83b374a9e22ac549b5c51d
    tools 977844c7af2aa555048a19d28e9fe6c392e7b8e9
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "030d584ade5f79aa2ed0ce067e8f7da50c9a10d5"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "975617b05ea8a58727e6c1a06b6161ff4185a9f2"
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
