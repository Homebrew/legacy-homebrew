require "language/go"

class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/spf13/hugo/archive/v0.15.tar.gz"
  sha256 "417106a9a52fd1740bcb8a0102684da13da389b9a126eb1829b61cfdf3d86b63"

  bottle do
    cellar :any_skip_relocation
    sha256 "f8eccd7f88d75c6840ba3cb6e7f1b8c6d1b3704ee8af835bd46a8db2ac27c0e9" => :el_capitan
    sha256 "dea76bc05569020c4732e27562d93d8b11b8f3e166e137b3865a78f5dfef877c" => :yosemite
    sha256 "910dff75a8cfd4ad6730892777222a041d8e89d8d5c6ecad6c2fd9677dc8f191" => :mavericks
  end

  head do
    url "https://github.com/spf13/hugo.git"
  end

  depends_on "go" => :build

  go_resource "bitbucket.org/pkg/inflect" do
    url "https://bitbucket.org/pkg/inflect",
      :revision => "8961c3750a47b8c0b3e118d52513b97adf85a7e8", :using => :hg
  end

  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
      :revision => "056c9bc7be7190eaa7715723883caffa5f8fa3e4"
  end

  go_resource "github.com/PuerkitoBio/purell" do
    url "https://github.com/PuerkitoBio/purell.git",
      :revision => "d69616f51cdfcd7514d6a380847a152dfc2a749d"
  end

  go_resource "github.com/cpuguy83/go-md2man" do
    url "https://github.com/cpuguy83/go-md2man.git",
      :revision => "71acacd42f85e5e82f70a55327789582a5200a90"
  end

  go_resource "github.com/dchest/cssmin" do
    url "https://github.com/dchest/cssmin.git",
      :revision => "a22e1d8daca3c08ffc1604201886e43bac04ceb9"
  end

  go_resource "github.com/eknkc/amber" do
    url "https://github.com/eknkc/amber.git",
      :revision => "144da19a9994994c069f0693294a66dd310e14a4"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
      :revision => "361d4c0ffd78338ebe0a9e6320cdbe115d7dc026"
  end

  go_resource "github.com/inconshreveable/mousetrap" do
    url "https://github.com/inconshreveable/mousetrap.git",
      :revision => "76626ae9c91c4f2a10f34cad8ce83ea42c93bb75"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
      :revision => "10da29423eb9a6269092eebdc2be32209612d9d2"
  end

  go_resource "github.com/kr/pretty" do
    url "https://github.com/kr/pretty.git",
      :revision => "e6ac2fc51e89a3249e82157fa0bb7a18ef9dd5bb"
  end

  go_resource "github.com/kr/text" do
    url "https://github.com/kr/text.git",
      :revision => "bb797dc4fb8320488f47bf11de07a733d7233e1f"
  end

  go_resource "github.com/magiconair/properties" do
    url "https://github.com/magiconair/properties.git",
      :revision => "6ac0b95f449268951dd5c100682ea687a9866ea1"
  end

  go_resource "github.com/miekg/mmark" do
    url "https://github.com/miekg/mmark.git",
      :revision => "9dca01c4e2b1ee2b3eab905fbbe8c756b033afc3"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "github.com/opennota/urlesc" do
    url "https://github.com/opennota/urlesc.git",
      :revision => "5fa9ff0392746aeae1c4b37fcc42c65afa7a9587"
  end

  go_resource "github.com/russross/blackfriday" do
    url "https://github.com/russross/blackfriday.git",
      :revision => "300106c228d52c8941d4b3de6054a6062a86dda3"
  end

  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
      :revision => "10ef21a441db47d8b13ebcc5fd2310f636973c77"
  end

  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
      :revision => "0ad340694159e622d71701b0debde0b68ed72f9c"
  end

  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
      :revision => "ee815aaf958c707ad07547cd62150d973710f747"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
      :revision => "1c44ec8d3f1552cac48999f9306da23c4d8a288b"
  end

  go_resource "github.com/spf13/fsync" do
    url "https://github.com/spf13/fsync.git",
      :revision => "1a03b59821319ad444dd28ea219e409e2815182e"
  end

  go_resource "github.com/spf13/jwalterweatherman" do
    url "https://github.com/spf13/jwalterweatherman.git",
      :revision => "c2aa07df593850a04644d77bb757d002e517a296"
  end

  go_resource "github.com/spf13/nitro" do
    url "https://github.com/spf13/nitro.git",
      :revision => "24d7ef30a12da0bdc5e2eb370a79c659ddccf0e8"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
      :revision => "08b1a584251b5b62f458943640fc8ebd4d50aaa5"
  end

  go_resource "github.com/spf13/viper" do
    url "https://github.com/spf13/viper.git",
      :revision => "e37b56e207dda4d79b9defe0548e960658ee8b6b"
  end

  go_resource "github.com/yosssi/ace" do
    url "https://github.com/yosssi/ace.git",
      :revision => "8e090bf0a6119b722012f08062c732d2434fbbb5"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
      :revision => "e6847002810c51f892a128333573eac5e2a62024"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://gopkg.in/fsnotify.v1.git",
      :revision => "2cdd39bd6129c6a49c74fb07fb9d77ba1271c572"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
  end


  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/spf13/"
    ln_sf buildpath, buildpath/"src/github.com/spf13/hugo"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"hugo", "main.go"

    # Build bash completion
    system bin/"hugo", "gen", "autocomplete", "--completionfile=#{buildpath}/hugo.sh"
    bash_completion.install "hugo.sh"

    # Build man pages; target dir man/ is hardcoded :(
    mkdir_p buildpath/"man/"
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert File.exist?("#{site}/config.toml")
  end
end
