require "language/go"

class Terraform < Formula
  desc "Tool to build, change, and version infrastructure"
  homepage "https://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.6.3.tar.gz"
  sha256 "2cc1cedb7c08310f49fb1c0a382248884aa6bd4a5e35461e2fb056fe14e3e60d"

  bottle do
    cellar :any
    sha256 "6a51fd8cb76c6d477eed5e1384a2b3945799efedac7e15b63ee5d49f215cf317" => :yosemite
    sha256 "b9c9fe043bf4b740167572de8eeab5ae17606e707dd6f8c81a8677e32dd9e08e" => :mavericks
    sha256 "30b629bd1ff2dd1a3ac49417171498862865d7975ad5a11cbfbd0061e816de6f" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/awslabs/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
        :revision => "26610c929a183317d5bfa24af9a4c5484bc50fc8"
  end

  terraform_deps = %w[
    github.com/Azure/azure-sdk-for-go 99b5c364c7be7088d138aef0afce0b5a70855b03
    github.com/Azure/go-pkcs12 a635c0684cd517745ca5c9552a312627791d5ba0
    github.com/armon/circbuf f092b4f207b6e5cce0569056fba9e1a2735cb6cf
    github.com/aws/aws-sdk-go 26610c929a183317d5bfa24af9a4c5484bc50fc8
    github.com/cyberdelia/heroku-go 594d483b9b6a8ddc7cd2f1e3e7d1de92fa2de665
    github.com/dylanmei/iso8601 2075bf119b58e5576c6ed9f867b8f3d17f2e54d4
    github.com/dylanmei/winrmtest 3e9661c52c45dab9a8528966a23d421922fca9b9
    github.com/fsouza/go-dockerclient a8690093fcc33c6d03838677c4d694406326fa76
    github.com/hashicorp/atlas-go d1d08e8e25f0659388ede7bb8157aaa4895f5347
    github.com/hashicorp/consul 00e35cdc416d7a3ab997dd8b930c63bd0e8b93f8
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint 88326f6851319068e7b34981032128c0b1a6524d
    github.com/hashicorp/go-multierror 56912fb08d85084aa318edcf2bba735b97cf35c5
    github.com/hashicorp/go-version 999359b6b7a041ce16e695d51e92145b83f01087
    github.com/hashicorp/hcl 54864211433d45cb780682431585b3e573b49e4a
    github.com/hashicorp/yamux 8e00b30457b1486b012f204b82ec92ae6b547de8
    github.com/imdario/mergo 61a52852277811e93e06d28e0d0c396284a7730b
    github.com/masterzen/simplexml 95ba30457eb1121fa27753627c774c7cd4e90083
    github.com/masterzen/winrm 23128e7b3dc1f8091aeff7aae82cb2112ce53c75
    github.com/masterzen/xmlpath 13f4951698adc0fa9c1dda3e275d489a24201161
    github.com/mitchellh/cli 8102d0ed5ea2709ade1243798785888175f6e415
    github.com/mitchellh/colorstring 61164e49940b423ba1f12ddbdf01632ac793e5e9
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir 1f6da4a72e57d4e7edd4a7295a585e0a3999a2d4
    github.com/mitchellh/gox a5a468f84d74eb51ece602cb113edeb37167912f
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/go-linereader 07bab5fdd9580500aea6ada0e09df4aa28e68abd
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/osext 0dd3f918b21bec95ace9dc86c7e70266cfc5c702
    github.com/mitchellh/packer 60bbe850ef0b7fec19eba1929d83e7267ca1572b
    github.com/mitchellh/panicwrap 45cbfd3bae250c7676c077fb275be1a2968e066a
    github.com/mitchellh/prefixedio 89d9b535996bf0a185f85b59578f2e245f9e1724
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    github.com/nu7hatch/gouuid 179d4d0c4d8d407a32af483c2354df1d2c91e6c3
    github.com/packer-community/winrmcp 743b1afe5ee3f6d5ba71a0d50673fa0ba2123d6b
    github.com/pearkes/cloudflare 19e280b056f3742e535ea12ae92a37ea7767ea82
    github.com/pearkes/digitalocean e966f00c2d9de5743e87697ab77c7278f5998914
    github.com/pearkes/dnsimple 2a807d118c9e52e94819f414a6ec0293b45cad01
    github.com/pearkes/mailgun 5b02e7e9ffee9869f81393e80db138f6ff726260
    github.com/rackspace/gophercloud efb1971cbd1d39f6fc762a86cccccfad387019e6
    github.com/satori/go.uuid 6b8e5b55d20d01ad47ecfe98e5171688397c61e9
    github.com/soniah/dnsmadeeasy 5578a8c15e33958c61cf7db720b6181af65f4a9e
    github.com/vaughan0/go-ini a98ad7ee00ec53921f08832bc06ecf7fd600e6a1
    github.com/xanzy/go-cloudstack 00319560eeca5e6ffef3ba048c97c126a465854f
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
    crypto 173ce04bfaf66c7bb0fa9d5c0bfd93e773909dbd
    net 4a71d182556e05375344f3da665304f3d5784ab4
    oauth2 8914e5017ca260f2a3a1575b1e6868874050d95e
    tools 4f50f44d7a3206e9e28b984e023efce2a4a75369
  ].each_slice(2) do |x, y|
    go_resource "golang.org/x/#{x}" do
      url "https://go.googlesource.com/#{x}.git", :revision => y
    end
  end

  go_resource "google.golang.org/api" do
    url "https://code.googlesource.com/google-api-go-client.git",
      :revision => "0a735f7ec81c85ce7ec31bf7a67e125ef62266ec"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git",
      :revision => "e34a32f9b0ecbc0784865fb2d47f3818c09521d4"
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
