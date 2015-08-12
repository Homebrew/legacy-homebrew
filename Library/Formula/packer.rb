require "language/go"

class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"

  # buildscript requires the .git directory be present
  url "https://github.com/mitchellh/packer.git",
    :tag => "v0.8.5", :revision => "60bbe850ef0b7fec19eba1929d83e7267ca1572b"

  bottle do
    cellar :any
    sha256 "2261153a51b3f10fac3e1c369670c91b440dac48ba02f2bca80278429efe8612" => :yosemite
    sha256 "d6b19119a54a30d7e82c37f18986bcf983e94bebfe13f637f164ae134ab82fda" => :mavericks
    sha256 "005ee193b33cbb49c0ade2b436cc0cb914bd8fc352104d01e8a8b89ebdb4ef9d" => :mountain_lion
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "a5a468f84d74eb51ece602cb113edeb37167912f"
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
      :revision => "8e00b30457b1486b012f204b82ec92ae6b547de8"
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
      :using => :hg, :revision => "69e2a90ed92d03812364aeb947b7068dc42e561e"
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
      :using => :hg, :revision => "9dd3b6b6e7b3e1b7f30c2b58c5ec5fff6bf9feff"
  end

  go_resource "github.com/ActiveState/tail" do
    url "https://github.com/ActiveState/tail.git",
      :revision => "4b368d1590196ade29993d6a0896591403180bbd"
  end

  go_resource "google.golang.org/api" do
    url "https://github.com/google/google-api-go-client.git",
      :revision => "0a735f7ec81c85ce7ec31bf7a67e125ef62266ec"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "83f1503f771a82af8a31f358eb825e9efb5dae6c"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "8914e5017ca260f2a3a1575b1e6868874050d95e"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "4a71d182556e05375344f3da665304f3d5784ab4"
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
      :revision => "73aaaa9eb61d74fbf7e256ca586a3a565b308eea"
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
