require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.8.tar.gz"
  sha256 "1a2e8c5a8b4dfd002c25d1cb345877fd3143c0a273a885c22dac78c01bbae556"

  bottle do
    cellar :any_skip_relocation
    sha256 "24c023117ac72bc3d88a713be1ef41941101fd0d5e44e6108280e3c8329a902d" => :el_capitan
    sha256 "56d0d3b2f8c5d9f3dc15cf0c1e0fe9fd86c94d8f3b369016c9b4580508b98d28" => :yosemite
    sha256 "ba8971b7566ee65e67c11f457e4b118ef38e09465d07f2ddaf18d624f3c9e7ae" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/apparentlymart/go-cidr a3ebdb999b831ecb6ab8a226e31b07b2b9061c47
    github.com/apparentlymart/go-rundeck-api cddcfbabbe903e9c8df35ff9569dbb8d67789200
    github.com/armon/circbuf bbbad097214e2918d8543d5201d12bfd7bca254d
    github.com/aws/aws-sdk-go eac6a331d353c78ab5815fc6a59c1ffe8e92afba
    github.com/Azure/azure-sdk-for-go 84843207ea0c77c8c8aecbe2e16ac77caa8ce9cc
    github.com/coreos/etcd dd733ca51d5f4c60def1403739b5701a7a7751c4
    github.com/cyberdelia/heroku-go 8344c6a3e281a99a693f5b71186249a8620eeb6b
    github.com/digitalocean/godo ccd7d9b6bbf2361014a8334ad3c9280b88299ef9
    github.com/DreamItGetIT/statuscake 8cbe86575f00210a6df2c19cb2f59b00cd181de3
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient dc4295a98977ab5b1983051bc169b784c4b423df
    github.com/go-ini/ini 03e0e7d51a13a91c765d8d0161246bc14a38001a
    github.com/google/go-querystring 2a60fc2ba6c19de80291203597d752e9ba58e4c0
    github.com/hashicorp/atlas-go 6c9afe8bb88099b424db07dea18f434371de8199
    github.com/hashicorp/consul 6db8acc6585e318168e2bf3c886d49a28a75d114
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint e4b2dc34c0f698ee04750bf2035d8b9384233e1b
    github.com/hashicorp/go-cleanhttp 5df5ddc69534f1a4697289f1dca2193fbb40213f
    github.com/hashicorp/go-getter c5e245982bdb4708f89578c8e0054d82b5197401
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-version 2b9865f60ce11e527bd1255ba82036d465570aa3
    github.com/hashicorp/hcl c40ec20b1285f01e9e75ec39f2bf2cff132891d3
    github.com/hashicorp/logutils 0dc08b1671f34c4250ce212759ebd880f743d883
    github.com/hashicorp/serf a72c0453da2ba628a013e98bf323a76be4aa1443
    github.com/hashicorp/yamux df949784da9ed028ee76df44652e42d37a09d7e4
    github.com/imdario/mergo bb554f9fd6ee4cd190eef868de608ced813aeda1
    github.com/jmespath/go-jmespath 3433f3ea46d9f8019119e7dd41274e112a2359a9
    github.com/kardianos/osext 10da29423eb9a6269092eebdc2be32209612d9d2
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
    github.com/mitchellh/packer 400d1e560009fac403a776532549841e40f3a4b8
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
    github.com/ugorji/go 357a44b2b13e2711a45e30016508134101477610
    github.com/vmware/govmomi 699ac6397b74781d2d6519ad2ae408298075e205
    github.com/xanzy/go-cloudstack 104168fa792713f5e04b76e2862779dc2ad85bcc
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  %w[
    crypto 7b85b097bf7527677d54d3220065e966a0e3b613
    net 195180cfebf7362bd243a52477697895128c8777
    oauth2 442624c9ec9243441e83b374a9e22ac549b5c51d
    tools 977844c7af2aa555048a19d28e9fe6c392e7b8e9
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "ece7143efeb53ec1839b960a0849db4e57d3cfa2"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "2375e186ca77be721a7c9c7b13a659738a8511d2"
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
