require "formula"
require "language/go"

class Terraform < Formula
  homepage "http://www.terraform.io/"
  url "https://github.com/hashicorp/terraform/archive/v0.3.7.tar.gz"
  sha1 "46fb3979465b8bd8a3bbee753c558965b7c1d043"

  bottle do
    cellar :any
    sha1 "3a3c2dab2c266e04efc3918fd4419887ce3fd1b9" => :yosemite
    sha1 "55bebac462b820fbd809ca0a5f99b30d0c20b5c9" => :mavericks
    sha1 "269a96df407c83be7419042a64f7dc4e6588c5e7" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git", :revision => "e8e6fd4fe12510cc46893dff18c5188a6a6dc549"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git", :revision => "2a105dc4ba99792ac380f48d154af4e10b822846"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git", :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git", :revision => "513e04c400ee2e81e97f5e011c08fb42c6f69b84"
  end

  go_resource "github.com/mitchellh/copystructure" do
    url "https://github.com/mitchellh/copystructure.git", :revision => "c101d94abf8cd5c6213c8300d0aed6368f2d6ede"
  end

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git", :revision => "9cdd861463675960a0a0083a7e2023e7b0c994d7"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git", :revision => "442e588f213303bec7936deba67901f8fc8f18b1"
  end

  go_resource "github.com/mitchellh/goamz" do
    url "https://github.com/mitchellh/goamz.git", :revision => "97673455debc43e44e645466f3af7ae7a2497700"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git", :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/pearkes/cloudflare" do
    url "https://github.com/pearkes/cloudflare.git", :revision => "19e280b056f3742e535ea12ae92a37ea7767ea82"
  end

  go_resource "github.com/hashicorp/consul" do
    url "https://github.com/hashicorp/consul.git", :revision => "0c7ca91c74587d0a378831f63e189ac6bf7bab3f"
  end

  go_resource "github.com/pearkes/digitalocean" do
    url "https://github.com/pearkes/digitalocean.git", :revision => "e83ade90c89779be9325f8add18dfae8de7eaaa5"
  end

  go_resource "github.com/pearkes/dnsimple" do
    url "https://github.com/pearkes/dnsimple.git", :revision => "1e0c2b0eb33ca7b5632a130d6d34376a1ea46c84"
  end

  go_resource "github.com/cyberdelia/heroku-go" do
    url "https://github.com/cyberdelia/heroku-go.git", :revision => "594d483b9b6a8ddc7cd2f1e3e7d1de92fa2de665"
  end

  go_resource "github.com/pearkes/mailgun" do
    url "https://github.com/pearkes/mailgun.git", :revision => "5b02e7e9ffee9869f81393e80db138f6ff726260"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git", :revision => "7d2d8c8a4e078ce3c58736ab521a40b37a504c52"
  end

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git", :revision => "f092b4f207b6e5cce0569056fba9e1a2735cb6cf"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git", :revision => "e3c2e3d39391e9beb9660ccd6b4bd9a2f38dd8a0"
  end

  go_resource "github.com/mitchellh/colorstring" do
    url "https://github.com/mitchellh/colorstring.git", :revision => "15fc698eaae194ff160846daf77922a45b9290a7"
  end

  go_resource "github.com/mitchellh/osext" do
    url "https://github.com/mitchellh/osext.git", :revision => "0dd3f918b21bec95ace9dc86c7e70266cfc5c702"
  end

  go_resource "github.com/mitchellh/panicwrap" do
    url "https://github.com/mitchellh/panicwrap.git", :revision => "45cbfd3bae250c7676c077fb275be1a2968e066a"
  end

  go_resource "github.com/mitchellh/prefixedio" do
    url "https://github.com/mitchellh/prefixedio.git", :revision => "89d9b535996bf0a185f85b59578f2e245f9e1724"
  end

  go_resource "github.com/mitchellh/go-linereader" do
    url "https://github.com/mitchellh/go-linereader.git", :revision => "07bab5fdd9580500aea6ada0e09df4aa28e68abd"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git", :revision => "b4f943b3f25da97dec8e26bee1c3269019de070d"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git", :revision => "88326f6851319068e7b34981032128c0b1a6524d"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git", :revision => "fcdddc395df1ddf4247c69bd436e84cfa0733f7e"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git", :revision => "36fb42e1e88262b05ae676ce0085dd73fd66abfd"
  end

  go_resource "google.golang.org/cloud" do
    url "https://code.googlesource.com/gocloud.git", :revision => "fffe461e194e54255fea3954c7197e300dc87811"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git", :revision => "947224908606a5aa6af4427c3a2cea51387aa38a"
  end

  go_resource "code.google.com/p/google-api-go-client" do
    url "https://code.google.com/p/google-api-go-client/", :revision => "6ddfebb10ece",
      :using => :hg
  end

  go_resource "code.google.com/p/go-uuid" do
    url "https://code.google.com/p/go-uuid/", :revision => "35bc42037350",
      :using => :hg
  end

  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto/", :revision => "69e2a90ed92d",
      :using => :hg
  end

  go_resource "github.com/hashicorp/atlas-go" do
    url "https://github.com/hashicorp/atlas-go.git", :revision => "d782d458598017712f7e188f32e6aacd843bbe99"
  end

  go_resource "github.com/xanzy/go-cloudstack" do
    url "https://github.com/xanzy/go-cloudstack.git", :revision => "6f5951088b74a98bd81e44cc5e8218170988c4a0"
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
      # Clear ATLAS_TOKEN env var to not run atlas acceptance tests
      # that would require an active atlas account
      system "make", "test", "ATLAS_TOKEN="

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
