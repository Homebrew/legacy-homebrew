require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.9.tar.gz"
  sha256 "0b71b9242ce24b38edb9b6341092a1dbe260f793be63057e96536128c2a62d6f"

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
    github.com/aws/aws-sdk-go f5560d971c22b44673247c6b77de26fe22e89189
    github.com/Azure/azure-sdk-for-go 01f39a2ee8de1e51edeeb4975d406c3901723f86
    github.com/Azure/go-autorest bdba0a8422e534e5b680cbd3453840a49f7736c6
    github.com/bgentry/speakeasy 36e9cfdd690967f4f690c6edcc9ffacd006014a0
    github.com/coreos/etcd cb3ca4f8fbc58a900e3b606c40b84d137a9b7abf
    github.com/cyberdelia/heroku-go 8344c6a3e281a99a693f5b71186249a8620eeb6b
    github.com/dgrijalva/jwt-go afef698c326bfd906b11659432544e5aae441d44
    github.com/digitalocean/godo 2688c11a02dc3deac65645c82c3c812f95e417bf
    github.com/DreamItGetIT/statuscake 8cbe86575f00210a6df2c19cb2f59b00cd181de3
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 025617847eb2cf9bd1d851bc3b22ed28e6245ce5
    github.com/fsouza/go-dockerclient 175e1df973274f04e9b459a62cffc49808f1a649
    github.com/go-chef/chef ea196660dd8700ad18911681b223fe6bfc29cd69
    github.com/go-ini/ini afbd495e5aaea13597b5e14fe514ddeaa4d76fc3
    github.com/golang/protobuf 2402d76f3d41f928c7902a765dfc872356dd3aad
    github.com/google/go-querystring 2a60fc2ba6c19de80291203597d752e9ba58e4c0
    github.com/hashicorp/atlas-go b66e377f52e316206efe71abba20e276d8790d86
    github.com/hashicorp/consul 81cac9aaa5c56aa42fe33e031dc65260ba31a373
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint e4b2dc34c0f698ee04750bf2035d8b9384233e1b
    github.com/hashicorp/go-cleanhttp ce617e79981a8fff618bb643d155133a8f38db96
    github.com/hashicorp/go-getter c5e245982bdb4708f89578c8e0054d82b5197401
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-retryablehttp 24fda80b7c713c52649e57ce20100d453f7bdb24
    github.com/hashicorp/go-version 2b9865f60ce11e527bd1255ba82036d465570aa3
    github.com/hashicorp/hcl 197e8d3cf42199cfd53cd775deb37f3637234635
    github.com/hashicorp/logutils 0dc08b1671f34c4250ce212759ebd880f743d883
    github.com/hashicorp/serf 39c7c06298b480560202bec00c2c77e974e88792
    github.com/hashicorp/yamux df949784da9ed028ee76df44652e42d37a09d7e4
    github.com/hmrc/vmware-govcd 8d41785649f2bd8e90f8fd34183e9f2c64322a83
    github.com/imdario/mergo bc0f15622cd2a38ef83388501e4cd6747665b164
    github.com/jmespath/go-jmespath c01cf91b011868172fdcd9f41838e80c9d716264
    github.com/kardianos/osext 29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc
    github.com/lib/pq 11fc39a580a008f1f39bb3d11d984fb34ed778d9
    github.com/lusis/go-artifactory 11648aea3ce529414641a1f0e4f48de844d8befe
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm 54ea5d01478cfc2afccec1504bd0dfcd8c260cfa
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mattn/go-isatty 56b76bdf51f7708750eac80fa38b952bb9f32639
    github.com/mitchellh/cli 43a4bc367e0d53f561d3d985b9dca84e15bd0554
    github.com/mitchellh/colorstring 8631ce90f28644f54aeedcb3e389a85174e067d1
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir d682a8f0cf139663a984ff12528da460ca963de9
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/gox 770c39f64e66797aa46b70ea953ff57d41658e40
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/packer d507b18eb4cf00b7d832c8c3fc7bb46b6377b551
    github.com/mitchellh/panicwrap a1e50bc201f387747a45ffff020f1af2d8759e88
    github.com/mitchellh/prefixedio 6e6954073784f7ee67b28f2d22749d6479151ed7
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    github.com/nesv/go-dynect 841842b16b39cf2b5007278956976d7d909bd98b
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 3d184cea22ee1c41ec1697e0d830ff0c78f7ea97
    github.com/packethost/packngo f03d7dc788a8b57b62d301ccb98c950c325756f8
    github.com/pborman/uuid dee7705ef7b324f27ceb85a121c61f2c2e8ce988
    github.com/pearkes/cloudflare 765ac1828a78ba49e6dc48309d56415c61806ac3
    github.com/pearkes/dnsimple 78996265f576c7580ff75d0cb2c606a61883ceb8
    github.com/pearkes/mailgun b88605989c4141d22a6d874f78800399e5bb7ac2
    github.com/rackspace/gophercloud c70720d7929fb03f6d2b329db5ad14d2ddefc418
    github.com/satori/go.uuid d41af8bb6a7704f00bc3b7cba9355ae6a5a80048
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/sthulb/mime 698462dc9685d7743511c26da726c1b0c1cfb111
    github.com/tent/http-link-go ac974c61c2f990f4115b119354b5e0b47550e888
    github.com/ugorji/go 646ae4a518c1c3be0739df898118d9bccf993858
    github.com/vmware/govmomi 6cecd8ad370459553e779632e33f9af1e4f5a3f0
    github.com/xanzy/go-cloudstack eaf4e42852ca95fdd2ad70e18abad8ccb55bb611
    github.com/xanzy/ssh-agent ba9c9e33906f58169366275e3450db66139a31a9
    github.com/ziutek/mymysql 75ce5fbba34b1912a3641adbd58cf317d7315821
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  %w[
    crypto f23ba3a5ee43012fcb4b92e1a2a405a92554f4f2
    net f1d3149ecb40ffadf4a28d39a30f9a125fe57bdf
    oauth2 2baa8a1b9338cf13d9eeb27696d761155fa480be
    sys 833a04a10549a95dc34458c195cbad61bbb6cb4d
    tools 977844c7af2aa555048a19d28e9fe6c392e7b8e9
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "77e7d383beb96054547729f49c372b3d01e196ff"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "1bff51b8fae8d33cb3dab8f7858c266ce001ee3e"
  end

  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
      :revision => "54bf9150c922186bfc45a00bf9dfcb91a5063275"
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
