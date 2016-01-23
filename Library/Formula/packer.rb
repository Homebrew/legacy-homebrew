require "language/go"

class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/mitchellh/packer.git",
      :tag => "v0.8.6",
      :revision => "f8f7b7a34c1be06058f5aca23a51247db12cdbc5"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "453cd39450e9d0306c6d0c4b37d3736d3b9e83833d5b1409a38024dab438004a" => :el_capitan
    sha256 "7ea89b7e2d68bf3e35c87961b3e87ad4c6a04227a5cd83349402b86fa878ba88" => :yosemite
    sha256 "5517da3ca33378e5848ae0208639553b8f7c50fd1a7b06b1d5022d87697b26f6" => :mavericks
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "ef1967b9f538fe467e6a82fc42ec5dff966ad4ea"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
      :revision => "a11ddd7a070196035bc94b6c04a2a0114c06a395"
  end

  go_resource "github.com/jmespath/go-jmespath" do
    url "https://github.com/jmespath/go-jmespath.git",
      :revision => "769e1c1b866562e1f513d2d1f8e10bbebd765a08"
  end

  go_resource "github.com/dylanmei/winrmtest" do
    url "https://github.com/dylanmei/winrmtest.git",
      :revision => "025617847eb2cf9bd1d851bc3b22ed28e6245ce5"
  end

  go_resource "github.com/masterzen/winrm" do
    url "https://github.com/masterzen/winrm.git",
      :revision => "27e0cc83c289bfdafe049dedd54f9fd7805927ea"
  end

  go_resource "github.com/masterzen/simplexml" do
    url "https://github.com/masterzen/simplexml.git",
      :revision => "95ba30457eb1121fa27753627c774c7cd4e90083"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "6b8e5b55d20d01ad47ecfe98e5171688397c61e9"
  end

  go_resource "github.com/nu7hatch/gouuid" do
    url "https://github.com/nu7hatch/gouuid.git",
      :revision => "179d4d0c4d8d407a32af483c2354df1d2c91e6c3"
  end

  go_resource "github.com/packer-community/winrmcp" do
    url "https://github.com/packer-community/winrmcp.git",
      :revision => "743b1afe5ee3f6d5ba71a0d50673fa0ba2123d6b"
  end

  go_resource "github.com/dylanmei/iso8601" do
    url "https://github.com/dylanmei/iso8601.git",
      :revision => "2075bf119b58e5576c6ed9f867b8f3d17f2e54d4"
  end

  go_resource "github.com/digitalocean/godo" do
    url "https://github.com/digitalocean/godo.git",
      :revision => "0d77b009a8e77c302d978200d37f410a48c938b4"
  end

  go_resource "github.com/google/go-querystring" do
    url "https://github.com/google/go-querystring.git",
      :revision => "547ef5ac979778feb2f760cdb5f4eae1a2207b86"
  end

  go_resource "github.com/tent/http-link-go" do
    url "https://github.com/tent/http-link-go.git",
      :revision => "ac974c61c2f990f4115b119354b5e0b47550e888"
  end

  go_resource "github.com/go-ini/ini" do
    url "https://github.com/go-ini/ini.git",
      :revision => "45bf59e51e747b1d61b3108a97549497a6efd3bc"
  end

  go_resource "gopkg.in/fsnotify.v0" do
    url "https://github.com/go-fsnotify/fsnotify.git",
      :branch => "v0",
      :revision => "ea925a0a47d225b2ca7f9932b01d2ed4f3ec74f6"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://github.com/go-fsnotify/fsnotify.git",
      :revision => "6549b98005f3e4026ad9f50ef7d5011f40ba1397"
  end

  go_resource "github.com/rackspace/gophercloud" do
    url "https://github.com/rackspace/gophercloud.git",
      :revision => "99eced5e19804f19b330fa383c2341c00494f4b7"
  end

  go_resource "github.com/klauspost/pgzip" do
    url "https://github.com/klauspost/pgzip.git",
      :revision => "eef48e26d9ea34e54914d640e7f4ba4383862f78"
  end

  go_resource "github.com/klauspost/compress" do
    url "https://github.com/klauspost/compress.git",
      :revision => "472994a292cb3a23a011a238cbd857a85e67dc3f"
  end

  go_resource "github.com/klauspost/cpuid" do
    url "https://github.com/klauspost/cpuid.git",
      :revision => "3b0816bb6cb682eea8e1973f4168b6c86880efe1"
  end

  go_resource "github.com/klauspost/crc32" do
    url "https://github.com/klauspost/crc32.git",
      :revision => "d7104f5ae105f017bc05710e9ecba7384e625e05"
  end

  go_resource "github.com/pierrec/lz4" do
    url "https://github.com/pierrec/lz4.git",
      :revision => "4bdd4b0658f3a896d17b5364b94565df0cf55948"
  end

  go_resource "github.com/pierrec/xxHash" do
    url "https://github.com/pierrec/xxHash.git",
      :revision => "284d0fce1d182611739b90eb4fe4eff58e13d420"
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
      :revision => "d1d08e8e25f0659388ede7bb8157aaa4895f5347"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git",
      :revision => "88326f6851319068e7b34981032128c0b1a6524d"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
      :revision => "56912fb08d85084aa318edcf2bba735b97cf35c5"
  end

  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git",
      :revision => "999359b6b7a041ce16e695d51e92145b83f01087"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "ae139c4ae7fe21e9d99459d2acc57967cebb6918"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "8102d0ed5ea2709ade1243798785888175f6e415"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "github.com/mitchellh/osext" do
    url "https://github.com/mitchellh/osext.git",
      :revision => "0dd3f918b21bec95ace9dc86c7e70266cfc5c702"
  end

  go_resource "github.com/mitchellh/panicwrap" do
    url "https://github.com/mitchellh/panicwrap.git",
      :revision => "45cbfd3bae250c7676c077fb275be1a2968e066a"
  end

  go_resource "github.com/mitchellh/prefixedio" do
    url "https://github.com/mitchellh/prefixedio.git",
      :revision => "89d9b535996bf0a185f85b59578f2e245f9e1724"
  end

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git",
      :revision => "eecf4c70c626c7cfbb95c90195bc34d386c74ac6"
  end

  go_resource "code.google.com/p/go.crypto" do
    url "https://code.google.com/p/go.crypto/",
        :using => :hg,
        :revision => "69e2a90ed92d03812364aeb947b7068dc42e561e"
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
      :revision => "4b368d1590196ade29993d6a0896591403180bbd"
  end

  go_resource "google.golang.org/api" do
    url "https://github.com/google/google-api-go-client.git",
      :revision => "a5c3e2a4792aff40e59840d9ecdff0542a202a80"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "81bf7719a6b7ce9b665598222362b50122dfc13b"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "397fe7649477ff2e8ced8fc0b2696f781e53745a"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "7654728e381988afd88e58cabfd6363a5ea91810"
  end

  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
      :revision => "cdd515334b113fdc9b35cb1e7a3b457eeb5ad5cf"
  end

  go_resource "google.golang.org/cloud" do
    url "https://github.com/GoogleCloudPlatform/gcloud-golang.git",
      :revision => "e34a32f9b0ecbc0784865fb2d47f3818c09521d4"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "59b73b37c1e45995477aae817e4a653c89a858db"
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
