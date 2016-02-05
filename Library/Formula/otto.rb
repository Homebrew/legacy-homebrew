require "language/go"

class Otto < Formula
  desc "Development and deployment system designed as the successor to Vagrant"
  homepage "https://ottoproject.io"
  url "https://github.com/hashicorp/otto.git",
      :tag => "v0.2.0",
      :revision => "d3d825bb135a2fa27a604e82e40f60151a5e2118"
  revision 1

  head "https://github.com/hashicorp/otto.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f527af6c8898e57e8980265417d5668e9afa3fff77ad80a302b4c9f30fadbb69" => :el_capitan
    sha256 "b58b7ecfeca7fb51a5bde24a52c490933c1db8af432bd83e9becd135a3b62dd1" => :yosemite
    sha256 "43452b4d11dc836d12198e1589e77f342b0a473995216f667785c1aa568352eb" => :mavericks
  end

  depends_on "go" => :build

  otto_deps = %w[
    github.com/apparentlymart/go-cidr a3ebdb999b831ecb6ab8a226e31b07b2b9061c47
    github.com/armon/circbuf bbbad097214e2918d8543d5201d12bfd7bca254d
    github.com/armon/go-radix fbd82e84e2b13651f3abc5ffd26b65ba71bc8f93
    github.com/aws/aws-sdk-go b7b1a098eeebcdf7db0af5818e255dc8569b88ce
    github.com/bgentry/speakeasy 36e9cfdd690967f4f690c6edcc9ffacd006014a0
    github.com/boltdb/bolt 25b28102db2053fa885b2a4798d5dfa94745f4b6
    github.com/flosch/pongo2 a269242022ae534b052672d6a9326a40560a63e7
    github.com/go-ini/ini afbd495e5aaea13597b5e14fe514ddeaa4d76fc3
    github.com/hashicorp/atlas-go b66e377f52e316206efe71abba20e276d8790d86
    github.com/hashicorp/errwrap 7554cd9344cec97297fa6649b055a8c98c2a1e55
    github.com/hashicorp/go-checkpoint e4b2dc34c0f698ee04750bf2035d8b9384233e1b
    github.com/hashicorp/go-cleanhttp ce617e79981a8fff618bb643d155133a8f38db96
    github.com/hashicorp/go-getter c5e245982bdb4708f89578c8e0054d82b5197401
    github.com/hashicorp/go-multierror d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5
    github.com/hashicorp/go-version 2b9865f60ce11e527bd1255ba82036d465570aa3
    github.com/hashicorp/hcl 197e8d3cf42199cfd53cd775deb37f3637234635
    github.com/hashicorp/terraform 6d1d46c47ced8880ff4af5d48e49572c62fe7df6
    github.com/hashicorp/vault 4fa678131a73a77cbac7cb456fb69950d3146ca6
    github.com/hashicorp/yamux df949784da9ed028ee76df44652e42d37a09d7e4
    github.com/jmespath/go-jmespath c01cf91b011868172fdcd9f41838e80c9d716264
    github.com/jteeuwen/go-bindata a0ff2567cfb70903282db057e799fd826784d41d
    github.com/kardianos/osext 29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc
    github.com/mattn/go-isatty 56b76bdf51f7708750eac80fa38b952bb9f32639
    github.com/mitchellh/cli cb6853d606ea4a12a15ac83cc43503df99fd28fb
    github.com/mitchellh/iochan 87b45ffd0e9581375c491fef3d32130bb15c5bd7
    github.com/mitchellh/colorstring 8631ce90f28644f54aeedcb3e389a85174e067d1
    github.com/mitchellh/copystructure 6fc66267e9da7d155a9d3bd489e00dad02666dc6
    github.com/mitchellh/go-homedir d682a8f0cf139663a984ff12528da460ca963de9
    github.com/mitchellh/gox 39862d88e853ecc97f45e91c1cdcb1b312c51eaa
    github.com/mitchellh/ioprogress 8163955264568045f462ae7e2d6d07b2001fc997
    github.com/mitchellh/mapstructure 281073eb9eb092240d33ef253c404f1cca550309
    github.com/mitchellh/panicwrap a1e50bc201f387747a45ffff020f1af2d8759e88
    github.com/mitchellh/prefixedio 6e6954073784f7ee67b28f2d22749d6479151ed7
    github.com/mitchellh/reflectwalk eecf4c70c626c7cfbb95c90195bc34d386c74ac6
    gopkg.in/flosch/pongo2.v3 5e81b817a0c48c1c57cdf1a9056cf76bdee02ca9
  ]
  otto_deps.each_slice(2) do |x, y|
    go_resource x do
      url "https://#{x}.git", :revision => y
    end
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "803f01ea27e23d998825ec085f0d153cac01c828"
  end

  go_resource "golang.org/x/tools" do
    url "https://go.googlesource.com/tools.git",
      :revision => "4ad533583d0194672e7d3bc6fb8b67c8e905d853"
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
