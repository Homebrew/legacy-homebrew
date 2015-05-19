require "language/go"

class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"

  # buildscript requires the .git directory be present
  url "https://github.com/mitchellh/packer.git",
    :tag => "v0.7.5", :revision => "9cd66feeacbd9cb318b72eb5ed59428c5b8c37ac"

  bottle do
    cellar :any
    sha256 "4c62e5691329f9c274001400df487c090f5a0debbf3067cf977ac96e356f883e" => :yosemite
    sha256 "6c6894eb419f8677c13c34027e8897716f40a5f14bf0561869d99c8c6b4d8740" => :mavericks
    sha256 "1e6676f09ec0c145223f025254d7cf636cf13a240fc274d3711319970cafebf0" => :mountain_lion
  end

  # All of these patches come from the upstream repo and will be in the next release.
  #
  # Fixes reference to "BuildID" field in an atlas struct
  patch do
    url "https://github.com/mitchellh/packer/commit/ddb966061f88709537c93f16f7c4066ddf2b8adf.patch"
    sha256 "f3fd4a516da76b7fd9623bc02ac020766c0f13f3f85931d74b75e0d50b99fdb8"
  end

  # "multiple-value c.client.CreateBuildConfig() in single-value context"
  patch do
    url "https://github.com/mitchellh/packer/commit/17d4c4396c182ba77518d9d06f639b0ee49f295c.patch"
    sha256 "3850821cb6e6a82de3581e3e65b55c662d4a2f3443823805abca7176a8aa8ccd"
  end

  # next two patches: "not enough arguments in call to c.client.UploadBuildConfigVersion"
  patch do
    url "https://github.com/mitchellh/packer/commit/8e0c7ace3aac455b0e51d20009c014406060aa21.patch"
    sha256 "d5755e6e6f8028ae928bbf0d0779c6ac6119cd3ae18ba41632490a0066968c59"
  end

  patch do
    url "https://gist.githubusercontent.com/mistydemeo/23f749fa73296deacd5a/raw/7e0441edfb22841f6c2ba6dbf9bc7c9ecdce01d3/packer-push-message.patch"
    sha256 "add040cd165240dd3b6a925886f01cd8c24611c121529a654cac246d7e0686d5"
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :tag => "v0.3.0", :revision => "54b619477e8932bbb6314644c867e7e6db7a9c71"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
      :revision => "b584a329b193e206025682ae6c10cdbe03b0cd77"
  end

  go_resource "github.com/hashicorp/atlas-go" do
    url "https://github.com/hashicorp/atlas-go.git",
      :revision => "6a87d5f443991e9916104392cd5fc77678843e1d"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git",
      :revision => "88326f6851319068e7b34981032128c0b1a6524d"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "71c2886f5a673a35f909803f38ece5810165097b"
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
      :revision => "6cc8bc522243675a2882b81662b0b0d2e04b99c9"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "442e588f213303bec7936deba67901f8fc8f18b1"
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
      :revision => "faaa223588dd7005e49bf66fa2d19e35c8c4d761"
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
      :revision => "068b72961a6bc5b4a82cf4fc14ccc724c0cfa73a"
  end

  go_resource "code.google.com/p/google-api-go-client" do
    url "https://code.google.com/p/google-api-go-client/",
      :using => :hg, :revision => "6ddfebb10ece847f1ae09c701834f1b15abbd8b2"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "74f810a0152f4c50a16195f6b9ff44afc35594e8"
  end

  # Note that this is *not* the latest commit; the API was changed after this
  # commit and Packer 0.7.5 can't build against the newer version.
  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2.git", :revision => "b3f9a68f05ff3f8b323cd6917f1f237cdbc6edaa"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "e0403b4e005737430c05a57aac078479844f919c"
  end

  # This specific commit is needed by the version of oauth2 in use
  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
      :revision => "c98f627282072b1230c8795abe98e2914c8a1de9"
  end

  go_resource "google.golang.org/cloud" do
    url "https://github.com/GoogleCloudPlatform/gcloud-golang.git",
      :revision => "de1c38e5af44da22abe7c3b14a1edcf6264dae55"
  end

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
      :revision => "abd3b412d3c2460d848b6b81478fcb4e542d6327"
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
      :revision => "03f3462e6e86a197451e1a13dc8eee68c970db57"
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
