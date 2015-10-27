require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.6.tar.gz"
  sha256 "183a1d0076757be3c89e9a1a29776f010adff3dfa2b241de315c99a831ba873c"

  bottle do
    cellar :any_skip_relocation
    sha256 "4fce79039d7b2091fb8f32ef100fbec130ea81ceec5069d24902c89d0bc7e8db" => :el_capitan
    sha256 "c201f60fc8ac61d1cf5ef4a5e014e8f671f7048e30c047d4347bd184edb9dc6f" => :yosemite
    sha256 "ef4b7bfca07bad05622c297b80f69ca96fc742064aaa5cb2fe54542cd2d40883" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/Azure/azure-sdk-for-go 3dcabb61c225af4013db7af20d4fe430fd09e311
    github.com/apparentlymart/go-cidr a3ebdb999b831ecb6ab8a226e31b07b2b9061c47
    github.com/apparentlymart/go-rundeck-api cddcfbabbe903e9c8df35ff9569dbb8d67789200
    github.com/armon/circbuf bbbad097214e2918d8543d5201d12bfd7bca254d
    github.com/aws/aws-sdk-go 66c840e9981dd121a4239fc25e33b6c1c1caa781
    github.com/awslabs/aws-sdk-go 66c840e9981dd121a4239fc25e33b6c1c1caa781
    github.com/coreos/etcd ae62a77de61d70f434ed848ba48b44247cb54c94
    github.com/digitalocean/godo c03bb099b8dc38e87581902a56885013a0865703
    github.com/cyberdelia/heroku-go 8344c6a3e281a99a693f5b71186249a8620eeb6b
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient 44f75219dec4d25d3ac5483d38d3ada7eaf047ab
    github.com/google/go-querystring 547ef5ac979778feb2f760cdb5f4eae1a2207b86
    github.com/hashicorp/atlas-go 6c9afe8bb88099b424db07dea18f434371de8199
    github.com/hashicorp/consul 6a350d5d19a41f94e0c99a933410e8545c4e7a51
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint e4b2dc34c0f698ee04750bf2035d8b9384233e1b
    github.com/hashicorp/go-cleanhttp 5df5ddc69534f1a4697289f1dca2193fbb40213f
    github.com/hashicorp/go-getter 2463fe5ef95a59a4096482fb9390b5683a5c380a
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-version 2b9865f60ce11e527bd1255ba82036d465570aa3
    github.com/hashicorp/hcl 4de51957ef8d4aba6e285ddfc587633bbfc7c0e8
    github.com/hashicorp/logutils 0dc08b1671f34c4250ce212759ebd880f743d883
    github.com/hashicorp/yamux ddcd0a6ec7c55e29f235e27935bf98d302281bd3
    github.com/imdario/mergo 61a52852277811e93e06d28e0d0c396284a7730b
    github.com/kardianos/osext 6e7f843663477789fac7c02def0d0909e969b4e5
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm e3e57d617b7d9573db6c98567a261916ff53cfb3
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mitchellh/cli 8102d0ed5ea2709ade1243798785888175f6e415
    github.com/mitchellh/colorstring 8631ce90f28644f54aeedcb3e389a85174e067d1
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir df55a15e5ce646808815381b3db47a8c66ea62f4
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/gox a5a468f84d74eb51ece602cb113edeb37167912f
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/osext 5e2d6d41470f99c881826dedd8c526728b783c9c
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/packer 8e63ce13028ed6a3204d7ed210c4790ea11d7db9
    github.com/mitchellh/panicwrap 1655d88c8ff7495ae9d2c19fd8f445f4657e22b0
    github.com/mitchellh/prefixedio 89d9b535996bf0a185f85b59578f2e245f9e1724
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 3d184cea22ee1c41ec1697e0d830ff0c78f7ea97
    github.com/packethost/packngo f03d7dc788a8b57b62d301ccb98c950c325756f8
    github.com/pborman/uuid cccd189d45f7ac3368a0d127efb7f4d08ae0b655
    github.com/pearkes/cloudflare 3d4cd12a4c3a7fc29b338b774f7f8b7e3d5afc2e
    github.com/pearkes/dnsimple 78996265f576c7580ff75d0cb2c606a61883ceb8
    github.com/pearkes/mailgun b88605989c4141d22a6d874f78800399e5bb7ac2
    github.com/rackspace/gophercloud 63ee53d682169b50b8dfaca88722ba19bd5b17a6
    github.com/satori/go.uuid 08f0718b61e95ddba0ade3346725fe0e4bf28ca6
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/tent/http-link-go ac974c61c2f990f4115b119354b5e0b47550e888
    github.com/ugorji/go 8a2a3a8c488c3ebd98f422a965260278267a0551
    github.com/vaughan0/go-ini a98ad7ee00ec53921f08832bc06ecf7fd600e6a1
    github.com/vmware/govmomi 6be2410334b7be4f6f8962206e49042207f99673
    github.com/xanzy/go-cloudstack 0e6e56fc0db3f48f060273f2e2ffe5d8d41b0112
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  %w[
    crypto c8b9e6388ef638d5a8a9d865c634befdc46a6784
    net 2cba614e8ff920c60240d2677bc019af32ee04e5
    oauth2 038cb4adce85ed41e285c2e7cc6221a92bfa44aa
    tools 4f50f44d7a3206e9e28b984e023efce2a4a75369
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "c83ee8e9b7e6c40a486c0992a963ea8b6911de67"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "2400193c85c3561d13880d34e0e10c4315bb02af"
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
