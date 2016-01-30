require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.10.tar.gz"
  sha256 "2d9f8b8c6c40e7321bf457eb14741ba5e3aa66b915076c867b107a8ce13bf6c4"

  bottle do
    cellar :any_skip_relocation
    sha256 "ad4fa082a1d877400a42778565990641594ef3fccc9bb178a1680b7a74327d93" => :el_capitan
    sha256 "5ea88e3b126a7645bf81d1864942e2ce7b9a7a173fcc2ef5e1f6080bbaaff8b3" => :yosemite
    sha256 "cec5341659b9141c7772bd52b63c9bf6ccc184e2946f576986aa7633ad89bf63" => :mavericks
  end

  depends_on "go" => :build

  terraform_deps = %w[
    github.com/Azure/azure-sdk-for-go 1cb9dff8c37b2918ad1ebd7b294d01100a153d27
    github.com/Azure/go-autorest 1af7c26b6889336922ac036a1f85c5fc1ed61ff2
    github.com/DreamItGetIT/statuscake 8cbe86575f00210a6df2c19cb2f59b00cd181de3
    github.com/apparentlymart/go-cidr a3ebdb999b831ecb6ab8a226e31b07b2b9061c47
    github.com/apparentlymart/go-rundeck-api 43fcd8fbcf18fd5929258c044b4e3dd0643f875e
    github.com/armon/circbuf bbbad097214e2918d8543d5201d12bfd7bca254d
    github.com/armon/go-radix 4239b77079c7b5d1243b7b4736304ce8ddb6f0f2
    github.com/aws/aws-sdk-go 87b1e60a50b09e4812dee560b33a238f67305804
    github.com/bgentry/speakeasy 36e9cfdd690967f4f690c6edcc9ffacd006014a0
    github.com/coreos/etcd 0020c63dec1bf3e2927b6e076ffbe86c1021f5ed
    github.com/cyberdelia/heroku-go 81c5afa1abcf69cc18ccc24fa3716b5a455c9208
    github.com/dgrijalva/jwt-go afef698c326bfd906b11659432544e5aae441d44
    github.com/digitalocean/godo f75d769b07edce8a73682dcf325b4404f366ab3d
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 025617847eb2cf9bd1d851bc3b22ed28e6245ce5
    github.com/fsouza/go-dockerclient 504b650c495df17b7f246b94fe2a2239a85bc73e
    github.com/go-chef/chef ea196660dd8700ad18911681b223fe6bfc29cd69
    github.com/go-ini/ini afbd495e5aaea13597b5e14fe514ddeaa4d76fc3
    github.com/golang/protobuf 6aaa8d47701fa6cf07e914ec01fde3d4a1fe79c3
    github.com/google/go-querystring 2a60fc2ba6c19de80291203597d752e9ba58e4c0
    github.com/hashicorp/atlas-go 0008886ebfa3b424bed03e2a5cbe4a2568ea0ff6
    github.com/hashicorp/consul a2d014a2469aa3856e5e10fd1270d9db7bcb8e13
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint e4b2dc34c0f698ee04750bf2035d8b9384233e1b
    github.com/hashicorp/go-cleanhttp ce617e79981a8fff618bb643d155133a8f38db96
    github.com/hashicorp/go-getter 848242c76c346ef0aeb34787753b068f5f6f92fe
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-retryablehttp 24fda80b7c713c52649e57ce20100d453f7bdb24
    github.com/hashicorp/go-version 7e3c02b30806fa5779d3bdfc152ce4c6f40e7b38
    github.com/hashicorp/hcl 578dd9746824a54637686b51a41bad457a56bcef
    github.com/hashicorp/logutils 0dc08b1671f34c4250ce212759ebd880f743d883
    github.com/hashicorp/serf e4ec8cc423bbe20d26584b96efbeb9102e16d05f
    github.com/hashicorp/yamux df949784da9ed028ee76df44652e42d37a09d7e4
    github.com/hmrc/vmware-govcd 5cd82f01aa1c97afa9b23ef6f4f42a60f3106003
    github.com/imdario/mergo b1859b199a7171589445bdea9fa8c19362613f80
    github.com/jmespath/go-jmespath c01cf91b011868172fdcd9f41838e80c9d716264
    github.com/kardianos/osext 29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc
    github.com/lib/pq 8ad2b298cadd691a77015666a5372eae5dbfac8f
    github.com/lusis/go-artifactory 7e4ce345df825841661d1b3ffbb1327083d4a22f
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm 54ea5d01478cfc2afccec1504bd0dfcd8c260cfa
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mattn/go-isatty 56b76bdf51f7708750eac80fa38b952bb9f32639
    github.com/mitchellh/cli cb6853d606ea4a12a15ac83cc43503df99fd28fb
    github.com/mitchellh/colorstring 8631ce90f28644f54aeedcb3e389a85174e067d1
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir d682a8f0cf139663a984ff12528da460ca963de9
    github.com/mitchellh/gox 770c39f64e66797aa46b70ea953ff57d41658e40
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/packer c1ac120828388b1fd01ce285959d13d34fdd54f0
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
    github.com/rackspace/gophercloud 680aa02616313d8399abc91f17a444cf9292f0e1
    github.com/satori/go.uuid d41af8bb6a7704f00bc3b7cba9355ae6a5a80048
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/sthulb/mime 698462dc9685d7743511c26da726c1b0c1cfb111
    github.com/tent/http-link-go ac974c61c2f990f4115b119354b5e0b47550e888
    github.com/ugorji/go 646ae4a518c1c3be0739df898118d9bccf993858
    github.com/vmware/govmomi 20c009ce9c493f0c714a9fffa5bda5fb84df2b6c
    github.com/xanzy/go-cloudstack fa516de9c8f07a186331b78823c2bb717461953f
    github.com/xanzy/ssh-agent ba9c9e33906f58169366275e3450db66139a31a9
    github.com/ziutek/mymysql 75ce5fbba34b1912a3641adbd58cf317d7315821
  ]

  terraform_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  %w[
    crypto 1f22c0103821b9390939b6776727195525381532
    net 04b9de9b512f58addf28c9853d50ebef61c3953e
    oauth2 8a57ed94ffd43444c0879fe75701732a38afc985
    sys eb2c74142fd19a79b3f237334c7384d5167b1b46
    tools 977844c7af2aa555048a19d28e9fe6c392e7b8e9
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "0caa37974a5f5ae67172acf68b4970f7864f994c"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "fb10e8da373d97f6ba5e648299a10b3b91f14cd5"
  end

  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
      :revision => "6bde959377a90acb53366051d7d587bfd7171354"
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
