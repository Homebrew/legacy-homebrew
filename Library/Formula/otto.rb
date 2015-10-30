require "language/go"

class Otto < Formula
  desc "Development and deployment system designed as the successor to Vagrant"
  homepage "https://ottoproject.io"
  url "https://github.com/hashicorp/otto.git",
      :tag => "v0.1.2",
      :revision => "cc1a81fbce872ab1e2eff6342b8fa273cd9ebc0e"

  head "https://github.com/hashicorp/otto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "d5cd70b1a6a9c90e6a71169d09ddd9889ee67a9f1b6ee087dc4f8aa43bef3997" => :el_capitan
    sha256 "e4b30c4da6a208a435ee3c423832582660a41f12faefdc2c90bda6f554b96293" => :yosemite
    sha256 "c0833235419c696f236157fa9540f8056ca2d64aa7e59db715535aec13108c03" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/jteeuwen/go-bindata" do
    url "https://github.com/jteeuwen/go-bindata.git",
      :revision => "a0ff2567cfb70903282db057e799fd826784d41d"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
      :revision => "823804e1ae08dbb14eb807afc7db9993bc9e3cc3"
  end

  go_resource "github.com/mitchellh/gox" do
    url "https://github.com/mitchellh/gox.git",
      :revision => "770c39f64e66797aa46b70ea953ff57d41658e40"
  end

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
      :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
  end

  go_resource "github.com/apparentlymart/go-cidr" do
    url "https://github.com/apparentlymart/go-cidr.git",
      :revision => "a3ebdb999b831ecb6ab8a226e31b07b2b9061c47"
  end

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git",
      :revision => "bbbad097214e2918d8543d5201d12bfd7bca254d"
  end

  go_resource "github.com/aws/aws-sdk-go" do
    url "https://github.com/aws/aws-sdk-go.git",
      :revision => "83bae04b770b2b9aae4c946f795149d294e147d3"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "119858097e94ac1089c404206de6f2eef3b22a9b"
  end

  go_resource "github.com/flosch/pongo2" do
    url "https://github.com/flosch/pongo2.git",
      :revision => "4bac3860f8edbc19717122ddd9776aa03c53cb46"
  end

  go_resource "github.com/hashicorp/atlas-go" do
    url "https://github.com/hashicorp/atlas-go.git",
      :revision => "6c9afe8bb88099b424db07dea18f434371de8199"
  end

  go_resource "github.com/hashicorp/errwrap" do
    url "https://github.com/hashicorp/errwrap.git",
      :revision => "7554cd9344cec97297fa6649b055a8c98c2a1e55"
  end

  go_resource "github.com/hashicorp/go-checkpoint" do
    url "https://github.com/hashicorp/go-checkpoint.git",
      :revision => "e4b2dc34c0f698ee04750bf2035d8b9384233e1b"
  end

  go_resource "github.com/hashicorp/go-cleanhttp" do
    url "https://github.com/hashicorp/go-cleanhttp.git",
      :revision => "5df5ddc69534f1a4697289f1dca2193fbb40213f"
  end

  go_resource "github.com/hashicorp/go-getter" do
    url "https://github.com/hashicorp/go-getter.git",
      :revision => "ed87cf163bcc928524f185164d988fac2db1c129"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
      :revision => "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5"
  end

  go_resource "github.com/hashicorp/go-version" do
    url "https://github.com/hashicorp/go-version.git",
      :revision => "2b9865f60ce11e527bd1255ba82036d465570aa3"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "4de51957ef8d4aba6e285ddfc587633bbfc7c0e8"
  end

  go_resource "github.com/hashicorp/terraform" do
    url "https://github.com/hashicorp/terraform.git",
      :revision => "82ad93539b43522705d203ecef6e2ff32a5404cb"
  end

  go_resource "github.com/hashicorp/vault" do
    url "https://github.com/hashicorp/vault.git",
      :revision => "8cf0d1444a5e73daf6317af383c3efd7857972e1"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "8102d0ed5ea2709ade1243798785888175f6e415"
  end

  go_resource "github.com/mitchellh/colorstring" do
    url "https://github.com/mitchellh/colorstring.git",
      :revision => "8631ce90f28644f54aeedcb3e389a85174e067d1"
  end

  go_resource "github.com/mitchellh/copystructure" do
    url "https://github.com/mitchellh/copystructure.git",
      :revision => "6fc66267e9da7d155a9d3bd489e00dad02666dc6"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
      :revision => "d682a8f0cf139663a984ff12528da460ca963de9"
  end

  go_resource "github.com/mitchellh/ioprogress" do
    url "https://github.com/mitchellh/ioprogress.git",
      :revision => "8163955264568045f462ae7e2d6d07b2001fc997"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "github.com/mitchellh/osext" do
    url "https://github.com/mitchellh/osext.git",
      :revision => "5e2d6d41470f99c881826dedd8c526728b783c9c"
  end

  go_resource "github.com/mitchellh/panicwrap" do
    url "https://github.com/mitchellh/panicwrap.git",
      :revision => "1655d88c8ff7495ae9d2c19fd8f445f4657e22b0"
  end

  go_resource "github.com/mitchellh/prefixedio" do
    url "https://github.com/mitchellh/prefixedio.git",
      :revision => "89d9b535996bf0a185f85b59578f2e245f9e1724"
  end

  go_resource "github.com/mitchellh/reflectwalk" do
    url "https://github.com/mitchellh/reflectwalk.git",
      :revision => "eecf4c70c626c7cfbb95c90195bc34d386c74ac6"
  end

  go_resource "github.com/vaughan0/go-ini" do
    url "https://github.com/vaughan0/go-ini.git",
      :revision => "a98ad7ee00ec53921f08832bc06ecf7fd600e6a1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "c8b9e6388ef638d5a8a9d865c634befdc46a6784"
  end

  go_resource "gopkg.in/flosch/pongo2.v3" do
    url "https://gopkg.in/flosch/pongo2.v3.git",
      :revision => "5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/otto").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/jteeuwen/go-bindata/go-bindata" do
      system "go", "install"
    end

    cd gopath/"src/golang.org/x/tools/cmd/stringer" do
      system "go", "install"
    end

    cd gopath/"src/github.com/mitchellh/gox" do
      system "go", "install"
    end

    cd gopath/"src/github.com/hashicorp/otto" do
      system "make", "dev"
      bin.install "bin/otto"
    end
  end

  test do
    system "#{bin}/otto", "--version"
  end
end
