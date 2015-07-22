require "language/go"

class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"

  # buildscript requires the .git directory be present
  url "https://github.com/mitchellh/packer.git",
    :tag => "v0.8.2", :revision => "28c80a648c7e35c320530561a00c889837bd6b22"

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
      :revision => "1b403631cd2d44764a68a9549874213cf95b285e"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git",
      :revision => "88326f6851319068e7b34981032128c0b1a6524d"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git",
      :revision => "999359b6b7a041ce16e695d51e92145b83f01087"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "b2e55852ddaf823a85c67f798080eb7d08acd71d"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "8102d0ed5ea2709ade1243798785888175f6e415"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "2caf8efc93669b6c43e0441cdc6aed17546c96f3"
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
      :revision => "a09229c13c2f13bbdedf7b31b506cad4c83ef3bf"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "2f677ffe0a128ed6d4e3ecb565e4d29a6c6365da"
  end

  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git",
      :revision => "8914e5017ca260f2a3a1575b1e6868874050d95e"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "d9558e5c97f85372afee28cf2b6059d7d3818919"
  end

  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
      :revision => "e335b53aaf7a699963a1cfea40b65ee3bf09f711"
  end

  go_resource "google.golang.org/cloud" do
    url "https://github.com/GoogleCloudPlatform/gcloud-golang.git",
      :revision => "feda659df33f28fe2d0524fad496b4d01a2015af"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "a1463b958edbdb9d1fa8daa3a0a469bf678a1b89"
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
