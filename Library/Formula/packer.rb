require "language/go"

class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/mitchellh/packer.git",
      :tag => "v0.9.0",
      :revision => "a643faae672ec8b8424352476d2b91b7a7f7b06e"

  bottle do
    cellar :any_skip_relocation
    sha256 "b7a14830cf403c63e03dec83bb09210c917b4e2d76a7bfb999149881aad7fb6b" => :el_capitan
    sha256 "659e417c8d87a3d403a62ab61335e0d51c16fbf3a3a3dfb32b344fd2635bb4e1" => :yosemite
    sha256 "001260faf5dca802111df1da59e26244c60f8de4379c85b3692f4c660b32dc4c" => :mavericks
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "ef1967b9f538fe467e6a82fc42ec5dff966ad4ea"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
      :revision => "8041be5461786460d86b4358305fbdf32d37cfb2"
  end

  go_resource "github.com/jmespath/go-jmespath" do
    url "https://github.com/jmespath/go-jmespath.git",
      :revision => "c01cf91b011868172fdcd9f41838e80c9d716264"
  end

  go_resource "github.com/dylanmei/winrmtest" do
    url "https://github.com/dylanmei/winrmtest.git",
      :revision => "025617847eb2cf9bd1d851bc3b22ed28e6245ce5"
  end

  go_resource "github.com/masterzen/winrm" do
    url "https://github.com/masterzen/winrm.git",
      :revision => "54ea5d01478cfc2afccec1504bd0dfcd8c260cfa"
  end

  go_resource "github.com/masterzen/simplexml" do
    url "https://github.com/masterzen/simplexml.git",
      :revision => "95ba30457eb1121fa27753627c774c7cd4e90083"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "d41af8bb6a7704f00bc3b7cba9355ae6a5a80048"
  end

  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
      :revision => "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end

  go_resource "github.com/packer-community/winrmcp" do
    url "https://github.com/packer-community/winrmcp.git",
      :revision => "3d184cea22ee1c41ec1697e0d830ff0c78f7ea97"
  end

  go_resource "github.com/dylanmei/iso8601" do
    url "https://github.com/dylanmei/iso8601.git",
      :revision => "2075bf119b58e5576c6ed9f867b8f3d17f2e54d4"
  end

  go_resource "github.com/digitalocean/godo" do
    url "https://github.com/digitalocean/godo.git",
      :revision => "6ca5b770f203b82a0fca68d0941736458efa8a4f"
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring.git",
      :revision => "2a60fc2ba6c19de80291203597d752e9ba58e4c0"
  end

  go_resource "github.com/tent/http-link-go" do
    url "https://github.com/tent/http-link-go.git",
      :revision => "ac974c61c2f990f4115b119354b5e0b47550e888"
  end

  go_resource "github.com/go-ini/ini" do
    url "https://github.com/go-ini/ini.git",
      :revision => "afbd495e5aaea13597b5e14fe514ddeaa4d76fc3"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://github.com/go-fsnotify/fsnotify.git",
      :revision => "8611c35ab31c1c28aa903d33cf8b6e44a399b09e"
  end

  go_resource "github.com/rackspace/gophercloud" do
    url "https://github.com/rackspace/gophercloud.git",
      :revision => "680aa02616313d8399abc91f17a444cf9292f0e1"
  end

  go_resource "github.com/klauspost/pgzip" do
    url "https://github.com/klauspost/pgzip.git",
      :revision => "47f36e165cecae5382ecf1ec28ebf7d4679e307d"
  end

  go_resource "github.com/klauspost/compress" do
    url "https://github.com/klauspost/compress.git",
      :revision => "f86d2e6d8a77c6a2c4e42a87ded21c6422f7557e"
  end

  go_resource "github.com/klauspost/cpuid" do
    url "https://github.com/klauspost/cpuid.git",
      :revision => "349c675778172472f5e8f3a3e0fe187e302e5a10"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
      :revision => "999f3125931f6557b991b2f8472172bdfa578d38"
  end

  go_resource "github.com/pierrec/lz4" do
    url "https://github.com/pierrec/lz4.git",
      :revision => "383c0d87b5dd7c090d3cddefe6ff0c2ffbb88470"
  end

  go_resource "github.com/pierrec/xxHash" do
    url "https://github.com/pierrec/xxHash.git",
      :revision => "5a004441f897722c627870a981d02b29924215fa"
  end

  go_resource "github.com/masterzen/xmlpath" do
    url "https://github.com/masterzen/xmlpath.git",
      :revision => "13f4951698adc0fa9c1dda3e275d489a24201161"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
      :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/hashicorp/atlas-go" do
    url "https://github.com/hashicorp/atlas-go.git",
      :revision => "0008886ebfa3b424bed03e2a5cbe4a2568ea0ff6"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git",
      :revision => "e4b2dc34c0f698ee04750bf2035d8b9384233e1b"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
      :revision => "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5"
  end

  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git",
      :revision => "7e3c02b30806fa5779d3bdfc152ce4c6f40e7b38"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "df949784da9ed028ee76df44652e42d37a09d7e4"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "5c87c51cedf76a1737bf5ca3979e8644871598a6"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
      :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
  end

  go_resource "github.com/mitchellh/panicwrap" do
    url "https://github.com/mitchellh/panicwrap.git",
      :revision => "a1e50bc201f387747a45ffff020f1af2d8759e88"
  end

  go_resource "github.com/mitchellh/prefixedio" do
    url "https://github.com/mitchellh/prefixedio.git",
      :revision => "6e6954073784f7ee67b28f2d22749d6479151ed7"
  end

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git",
      :revision => "eecf4c70c626c7cfbb95c90195bc34d386c74ac6"
  end

  go_resource "github.com/mitchellh/go-fs" do
    url "https://github.com/mitchellh/go-fs.git",
      :revision => "a34c1b9334e86165685a9449b782f20465eb8c69"
  end

  go_resource "github.com/mitchellh/goamz" do
    url "https://github.com/mitchellh/goamz.git",
      :revision => "caaaea8b30ee15616494ee68abd5d8ebbbef05cf"
  end

  go_resource "github.com/mitchellh/multistep" do
    url "https://github.com/mitchellh/multistep.git",
      :revision => "162146fc57112954184d90266f4733e900ed05a5"
  end

  go_resource "code.google.com/p/gosshold" do
    url "https://code.google.com/p/gosshold/",
        :using => :hg,
        :revision => "9dd3b6b6e7b3e1b7f30c2b58c5ec5fff6bf9feff"
  end

  go_resource "github.com/ActiveState/tail" do
    url "https://github.com/ActiveState/tail.git",
      :revision => "1a0242e795eeefe54261ff308dc685f7d29cc58c"
  end

  go_resource "google.golang.org/api" do
    url "https://github.com/google/google-api-go-client.git",
      :revision => "ddff2aff599105a55549cf173852507dfa094b7f"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "81bf7719a6b7ce9b665598222362b50122dfc13b"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "8a57ed94ffd43444c0879fe75701732a38afc985"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "6ccd6698c634f5d835c40c1c31848729e0cecda1"
  end

  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
      :revision => "6bde959377a90acb53366051d7d587bfd7171354"
  end

  go_resource "google.golang.org/cloud" do
    url "https://github.com/GoogleCloudPlatform/gcloud-golang.git",
      :revision => "5a3b06f8b5da3b7c3a93da43163b872c86c509ef"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "b982704f8bb716bb608144408cff30e15fbde841"
  end

  go_resource "github.com/mitchellh/gophercloud-fork-40444fb" do
    url "https://github.com/mitchellh/gophercloud-fork-40444fb.git",
      :revision => "40444fbc2b10960682b34e6822eb9179216e1ae1"
  end

  go_resource "github.com/racker/perigee" do
    url "https://github.com/racker/perigee.git",
      :revision => "44a7879d89b7040bcdb51164a83292ef5bf9deec"
  end

  go_resource "github.com/going/toolkit" do
    url "https://github.com/going/toolkit.git",
      :revision => "5bff591dc40da25dcc875d3fa1a3373d74d45411"
  end

  go_resource "github.com/mitchellh/go-vnc" do
    url "https://github.com/mitchellh/go-vnc.git",
      :revision => "723ed9867aed0f3209a81151e52ddc61681f0b01"
  end

  go_resource "github.com/howeyc/fsnotify" do
    url "https://github.com/howeyc/fsnotify.git",
      :revision => "4894fe7efedeeef21891033e1cce3b23b9af7ad2"
  end

  go_resource "gopkg.in/tomb.v1" do
    url "https://gopkg.in/tomb.v1.git",
      :revision => "dd632973f1e7218eb1089048e0798ec9ae7dceb8"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
      :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "github.com/armon/go-radix" do
    url "https://github.com/armon/go-radix.git",
        :revision => "4239b77079c7b5d1243b7b4736304ce8ddb6f0f2"
  end

  go_resource "github.com/bgentry/speakeasy" do
    url "https://github.com/bgentry/speakeasy.git",
        :revision => "36e9cfdd690967f4f690c6edcc9ffacd006014a0"
  end

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git",
        :revision => "7554cd9344cec97297fa6649b055a8c98c2a1e55"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
        :revision => "875fb671b3ddc66f8e2f0acc33829c8cb989a38d"
  end

  go_resource "github.com/hpcloud/tail" do
    url "https://github.com/hpcloud/tail.git",
        :revision => "1a0242e795eeefe54261ff308dc685f7d29cc58c"
  end

  go_resource "github.com/kr/fs" do
    url "https://github.com/kr/fs.git",
        :revision => "2788f0dbd16903de03cb8186e5c7d97b69ad387b"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "d682a8f0cf139663a984ff12528da460ca963de9"
  end

  go_resource "github.com/pkg/sftp" do
    url "https://github.com/pkg/sftp.git",
        :revision => "e84cc8c755ca39b7b64f510fe1fffc1b51f210a5"
  end

  go_resource "github.com/ugorji/go" do
    url "https://github.com/ugorji/go.git",
        :revision => "646ae4a518c1c3be0739df898118d9bccf993858"
  end

  go_resource "golang.org/x/sys" do
    url "https://go.googlesource.com/sys",
        :revision => "50c6bc5e4292a1d4e65c6e9be5f53be28bcbe28e"
  end

  go_resource "gopkg.in/xmlpath.v2" do
    url "https://gopkg.in/xmlpath.v2.git",
        :revision => "860cbeca3ebcc600db0b213c0e83ad6ce91f5739"
  end

  def install
    ENV["XC_OS"] = "darwin"
    ENV["XC_ARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath
    # For the gox buildtool used by packer, which doesn't need to
    # get installed permanently
    ENV.append_path "PATH", buildpath

    packerpath = buildpath/"src/github.com/mitchellh/packer"
    packerpath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"
    mkdir_p buildpath/"bin"

    cd "src/github.com/mitchellh/gox" do
      system "go", "build"
      buildpath.install "gox"
    end

    cd "src/github.com/mitchellh/packer" do
      system "make", "bin"
      bin.install Dir["bin/*"]
    end
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<-EOS.undent
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", minimal
  end
end
