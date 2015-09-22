require "language/go"

class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.14.tar.gz"
  sha256 "67e0fda342e6a35490ce03f5535e30cf04bc06775c47bacf416d96d83cce4535"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "2b540458a623faeee8c5c6d025a30d67c2102c09cadf809b27385d1aef815294" => :el_capitan
    sha256 "4fe2e1d6bd266043f1a4403267c32fc5c792d24f7d143b90ada2c80d6e7ab162" => :yosemite
    sha256 "765aaa87fcc5f35ee29a2f220c41b61c80be31ce69a358bb9f27c52541b83e9e" => :mavericks
    sha256 "58f9a66a37f46bc5be803ca41ef5f8bc9b9eb4895f70255e1c6d08c94f6fd6e3" => :mountain_lion
  end

  head do
    url "https://github.com/spf13/hugo.git"

    go_resource "golang.org/x/text" do
      url "https://github.com/golang/text.git", :revision => "df923bbb63f8ea3a26bb743e2a497abd0ab585f7"
    end
  end

  depends_on "go" => :build

  go_resource "bitbucket.org/pkg/inflect" do
    url "https://bitbucket.org/pkg/inflect",
        :using => :hg,
        :revision => "8961c3750a47b8c0b3e118d52513b97adf85a7e8"
  end
  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end
  go_resource "github.com/dchest/cssmin" do
    url "https://github.com/dchest/cssmin.git",
        :revision => "a22e1d8daca3c08ffc1604201886e43bac04ceb9"
  end
  go_resource "github.com/eknkc/amber" do
    url "https://github.com/eknkc/amber.git",
        :revision => "ee5a5b8364bb73899fdd529d23af6ad9230f8a06"
  end
  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "ecff5aabe41f13b4cdf897e3c0c9bbccbe552a29"
  end
  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "8fef92e41e22a70e700a96b29f066cda30ea24ef"
  end
  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
        :revision => "442e588f213303bec7936deba67901f8fc8f18b1"
  end
  go_resource "github.com/PuerkitoBio/purell" do
    url "https://github.com/PuerkitoBio/purell.git",
        :revision => "d69616f51cdfcd7514d6a380847a152dfc2a749d"
  end
  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
        :revision => "386ef80f18233ea97960e855a54382ec446c6637"
  end
  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
        :revision => "e54aac2c6a0e639c31cbfe95944a1e9c01c05606"
  end
  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
        :revision => "4d07383ffe94b5e5a6fa3af9211374a4507a0184"
  end
  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "c11766b405b388c6bbafaa1c8b3ad2eaf471b7b6"
  end
  go_resource "github.com/spf13/fsync" do
    url "https://github.com/spf13/fsync.git",
        :revision => "1fdf08f822b05e59a6515ee151b683c3a02efea5"
  end
  go_resource "github.com/spf13/jwalterweatherman" do
    url "https://github.com/spf13/jwalterweatherman.git",
        :revision => "3d60171a64319ef63c78bd45bd60e6eab1e75f8b"
  end
  go_resource "github.com/spf13/nitro" do
    url "https://github.com/spf13/nitro.git",
        :revision => "24d7ef30a12da0bdc5e2eb370a79c659ddccf0e8"
  end
  go_resource "github.com/spf13/viper" do
    url "https://github.com/spf13/viper.git",
        :revision => "be782f3fee037d2db69c1c8af0e985e81e1ac273"
  end
  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "dab07ac62d4905d3e48d17dc549c684ac3b7c15a"
  end
  go_resource "github.com/yosssi/ace" do
    url "https://github.com/yosssi/ace.git",
        :revision => "78e48a2f0ac5fb5a642585f96b03a5f47f7775f5"
  end
  go_resource "github.com/miekg/mmark" do
    url "https://github.com/miekg/mmark.git",
        :revision => "8a5a95ecab1c0d187754b4074c0d6f5215a26565"
  end
  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
        :branch => "v2",
        :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213"
  end
  go_resource "gopkg.in/fsnotify.v1" do
    url "https://github.com/go-fsnotify/fsnotify.git",
        :revision => "6549b98005f3e4026ad9f50ef7d5011f40ba1397"
  end

  # dependency for blackfriday
  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "11a20b799bf22a02808c862eb6ca09f7fb38f84a"
  end

  # dependencies for cobra
  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "0ed81a961505a7dfaab5490049a7a324743e6f03"
  end
  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
        :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  # dependency for purell
  go_resource "github.com/opennota/urlesc" do
    url "https://github.com/opennota/urlesc.git",
        :revision => "5fa9ff0392746aeae1c4b37fcc42c65afa7a9587"
  end

  # dependencies for viper
  go_resource "github.com/kr/pretty" do
    url "https://github.com/kr/pretty.git",
        :revision => "cb0850c1681cbca3233e84f7e6ec3e4c3f352085"
  end
  go_resource "github.com/xordataexchange/crypt" do
    url "https://github.com/xordataexchange/crypt.git",
        :revision => "93de65664ef094aa5acff4f5201ac17580370af7"
  end
  go_resource "github.com/magiconair/properties" do
    url "https://github.com/magiconair/properties.git",
        :revision => "d5929c67198951106f49f7ea425198d0f1a08f7f"
  end

  # dependency for pretty
  go_resource "github.com/kr/text" do
    url "https://github.com/kr/text.git",
        :revision => "6807e777504f54ad073ecef66747de158294b639"
  end

  # dependencies for crypt
  go_resource "github.com/armon/consul-api" do
    url "https://github.com/armon/consul-api.git",
        :revision => "dcfedd50ed5334f96adee43fc88518a4f095e15c"
  end
  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto",
        :using => :git,
        :revision => "4d48e5fa3d62b5e6e71260571bf76c767198ca02"
  end
  go_resource "github.com/coreos/go-etcd" do
    url "https://github.com/coreos/go-etcd.git",
        :revision => "73a8ef737e8ea002281a28b4cb92a1de121ad4c6"
  end

  # dependency for go-etcd
  go_resource "github.com/coreos/etcd" do
    url "https://github.com/coreos/etcd.git",
        :revision => "b3e6ad136a184afbffd1a803f75955d393c53e21"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/spf13/"
    ln_sf buildpath, buildpath/"src/github.com/spf13/hugo"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"hugo", "main.go"

    system bin/"hugo", "genautocomplete", "--completionfile=#{buildpath}/hugo.sh"
    bash_completion.install "hugo.sh"
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert File.exist?("#{site}/config.toml")
  end
end
