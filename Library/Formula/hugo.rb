require "language/go"

class Hugo < Formula
  homepage "http://gohugo.io/"
  head "https://github.com/spf13/hugo.git"
  revision 1

  stable do
    url "https://github.com/spf13/hugo/archive/v0.13.tar.gz"
    sha256 "4d3f1fd0df1f993ef188b2e2c2e1c4a45411d9f7b4ff6ebcad24b9288e9ff278"
    # remove `-DEV` from version string to prevent confusion
    patch do
      url "https://gist.githubusercontent.com/dunn/b4a5c15815b9067d0dcf/raw/d64809d68b716e0ce3286dd685dd23eb475c18ec/hugo.diff"
      sha256 "1b8caa1dccd2001152de08b906d7429385c570243dbf7821a0e07f1643e2c388"
    end

    # corrects repository url for osext; remove in next release
    patch do
      url "https://github.com/spf13/hugo/commit/967d001ebe40cfe90992d953880356a495216202.diff"
      sha256 "5a991372a54ac049783926c1993d920f46ab52563ff1877e7aaddc40b5a79e22"
    end
  end

  bottle do
    cellar :any
    sha256 "318cd60e3fd01d0876952ca5eac6870da04f40d1f0513751fce8fc85fef9f200" => :yosemite
    sha256 "28a230b589cb78a4868449409633871c7983d2f385d1a6e64538236b35a19f1c" => :mavericks
    sha256 "ec9257d512d512ca607360f59902a07e0eec1b2e07d7cbb0ac7639407f715c37" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build
  depends_on :hg => :build

  go_resource "bitbucket.org/pkg/inflect" do
    url "https://bitbucket.org/pkg/inflect",
        :using => :hg,
        :revision => "8961c3750a47b8c0b3e118d52513b97adf85a7e8"
  end
  go_resource "github.com/BurntSushi/toml" do
    url "https://github.com/BurntSushi/toml.git",
        :revision => "443a628bc233f634a75bcbdd71fe5350789f1afa"
  end
  go_resource "github.com/dchest/cssmin" do
    url "https://github.com/dchest/cssmin.git",
        :revision => "a22e1d8daca3c08ffc1604201886e43bac04ceb9"
  end
  go_resource "github.com/eknkc/amber" do
    url "https://github.com/eknkc/amber.git",
        :revision => "dade3a75e1ab1cf0c2cafae1397b32a99aaaef4a"
  end
  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "2dbddebb8266b93c5e6b119efb54e89043186f3f"
  end
  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "ccfcd0245381f0c94c68f50626665eed3c6b726a"
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
        :revison => "77efab57b2f74dd3f9051c79752b2e8995c8b789"
  end
  go_resource "github.com/spf13/afero" do
    url "https://github.com/spf13/afero.git",
        :revision => "139e50e29af82d1d998f0e38fabf4947c668acc6"
  end
  go_resource "github.com/spf13/cast" do
    url "https://github.com/spf13/cast.git",
        :revision => "2c4fdb5416dd394ff5e61fcdb8eb4f09e46a2ed8"
  end
  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
        :revision => "f8e1ec56bdd7494d309c69681267859a6bfb7549"
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
        :revision => "5b0b926e3dd4bd9bc75a2b9fac23279c9fae2d9f"
  end
  go_resource "github.com/stretchr/testify" do
    url "https://github.com/stretchr/testify.git",
        :revision => "e4ec8152c15fc46bd5056ce65997a07c7d415325"
  end
  go_resource "github.com/yosssi/ace" do
    url "https://github.com/yosssi/ace.git",
        :revision => "1f82044938a7180f6fb6bbb3a29688d1e6dbe74b"
  end
  go_resource "gopkg.in/fsnotify.v0" do
    url "https://github.com/go-fsnotify/fsnotify.git",
        :branch => "v0",
        :revision => "ea925a0a47d225b2ca7f9932b01d2ed4f3ec74f6"
  end
  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
        :branch => "v2",
        :revision => "49c95bdc21843256fb6c4e0d370a05f24a0bf213"
  end

  # dependency for blackfriday
  go_resource "github.com/shurcooL/sanitized_anchor_name" do
    url "https://github.com/shurcooL/sanitized_anchor_name.git",
        :revision => "8e87604bec3c645a4eeaee97dfec9f25811ff20d"
  end

  # dependency for cobra
  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
        :revision => "370c3171201099fa6b466db45c8a032cbce33d8d"
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
        :revision => "0499a3c94698e44032bd5fab8ba6f45672406678"
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
        :revision => "1351f936d976c60a0a48d728281922cf63eafb8d"
  end
  go_resource "github.com/coreos/go-etcd" do
    url "https://github.com/coreos/go-etcd.git",
        :revision => "4734e7aca379f0d7fcdf04fbb2101696a4b45ce8"
  end

  # dependency for go-etcd
  go_resource "github.com/coreos/etcd" do
    url "https://github.com/coreos/etcd.git",
        :revision => "a2be25cba4bb74756890dcd21dd67c66decdfd77"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/spf13/"
    ln_sf buildpath, buildpath/"src/github.com/spf13/hugo"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "main.go"
    bin.install "main" => "hugo"
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert File.exist?("#{site}/config.toml")
  end
end
