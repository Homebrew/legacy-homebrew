require "language/go"

class Juju < Formula
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.23/1.23.1/+download/juju-core_1.23.1.tar.gz"
  sha256 "e0a40b95b71385185938cb78fa60855ac15cd2270820028caecd24073f69a2e4"

  head "https://github.com/juju/juju.git"

  bottle do
    cellar :any
    sha256 "906ff5eec585e9cb02f89aecef769da89e1e7f8562d4fd164ca01888f9643fd9" => :yosemite
    sha256 "a98d8b543243cebfaf7791e9d916d7e489eb94104e5fb9fa4e4cd61aaa4de11c" => :mavericks
    sha256 "facdb795dcccf8425d0dc4066f4908c6be77184355f04e18849e2732f9627c05" => :mountain_lion
  end

  depends_on "go" => :build
  depends_on "bazaar" => :build

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "8fef92e41e22a70e700a96b29f066cda30ea24ef"
  end
  go_resource "github.com/kardianos/service" do
    url "https://github.com/kardianos/service.git",
        :revision => "3ed03fd6f765f40387481072357a2b624f236754"
  end
  go_resource "code.google.com/p/winsvc" do
    url "https://code.google.com/p/winsvc/",
        :using => :hg,
        :revision => "d6f79143ccd1138cc9d86c9fc75b1d6f8b1b95fb"
  end
  go_resource "github.com/ajstarks/svgo" do
    url "https://github.com/ajstarks/svgo.git",
        :revision => "89e3ac64b5b3e403a5e7c35ea4f98d45db7b4518"
  end
  go_resource "github.com/altoros/gosigma" do
    url "https://github.com/altoros/gosigma.git",
        :revision => "31228935eec685587914528585da4eb9b073c76d"
  end
  go_resource "github.com/bmizerany/pat" do
    url "https://github.com/bmizerany/pat.git",
        :revision => "48be7df2c27e1cec821a3284a683ce6ef90d9052"
  end
  go_resource "github.com/coreos/go-systemd" do
    url "https://github.com/coreos/go-systemd.git",
        :revision => "2d21675230a81a503f4363f4aa3490af06d52bb8"
  end
  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "145fabdb1ab757076a70a886d092a3af27f66f4c"
  end
  go_resource "github.com/godbus/dbus" do
    url "https://github.com/godbus/dbus.git",
        :revision => "88765d85c0fdadcd98a54e30694fa4e4f5b51133"
  end
  go_resource "github.com/joyent/gocommon" do
    url "https://github.com/joyent/gocommon.git",
        :revision => "40c7818502f7c1ebbb13dab185a26e77b746ff40"
  end
  go_resource "github.com/joyent/gomanta" do
    url "https://github.com/joyent/gomanta.git",
        :revision => "cabd97b029d931836571f00b7e48c331809a30b7"
  end
  go_resource "github.com/joyent/gosdc" do
    url "https://github.com/joyent/gosdc.git",
        :revision => "2f11feadd2d9891e92296a1077c3e2e56939547d"
  end
  go_resource "github.com/joyent/gosign" do
    url "https://github.com/joyent/gosign.git",
        :revision => "0da0d5f1342065321c97812b1f4ac0c2b0bab56c"
  end
  go_resource "github.com/juju/blobstore" do
    url "https://github.com/juju/blobstore.git",
        :revision => "1591df2bf102f9cbeeb9145d22c6ccc29a6804ef"
  end
  go_resource "github.com/juju/cmd" do
    url "https://github.com/juju/cmd.git",
        :revision => "d585b5672a9bec4e04b800ecb69a5035562b06eb"
  end
  go_resource "github.com/juju/errors" do
    url "https://github.com/juju/errors.git",
        :revision => "4567a5e69fd3130ca0d89f69478e7ac025b67452"
  end
  go_resource "github.com/juju/gojsonpointer" do
    url "https://github.com/juju/gojsonpointer.git",
        :revision => "afe8b77aa08f272b49e01b82de78510c11f61500"
  end
  go_resource "github.com/juju/gojsonreference" do
    url "https://github.com/juju/gojsonreference.git",
        :revision => "f0d24ac5ee330baa21721cdff56d45e4ee42628e"
  end
  go_resource "github.com/juju/gojsonschema" do
    url "https://github.com/juju/gojsonschema.git",
        :revision => "e1ad140384f254c82f89450d9a7c8dd38a632838"
  end
  go_resource "github.com/juju/govmomi" do
    url "https://github.com/juju/govmomi.git",
        :revision => "4354a88d4b34abe467215f77c2fc1cb9f78b66f7"
  end
  go_resource "github.com/juju/httpprof" do
    url "https://github.com/juju/httpprof.git",
        :revision => "14bf14c307672fd2456bdbf35d19cf0ccd3cf565"
  end
  go_resource "github.com/juju/jujusvg" do
    url "https://github.com/juju/jujusvg.git",
        :revision => "28683402583926ce903491c14a07cdc5cb371adb"
  end
  go_resource "github.com/juju/loggo" do
    url "https://github.com/juju/loggo.git",
        :revision => "6d22922ff98aac6608b8a58191bd6b2e1dac3fca"
  end
  go_resource "github.com/juju/names" do
    url "https://github.com/juju/names.git",
        :revision => "2b65d264b29346482c291c854168295f350cf323"
  end
  go_resource "github.com/juju/persistent-cookiejar" do
    url "https://github.com/juju/persistent-cookiejar.git",
        :revision => "beee02cb39231c7ad4a01a677fc54c48d2b46b08"
  end
  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "aa5bb718d4d435629821789cb90970319f57bfe5"
  end
  go_resource "github.com/juju/replicaset" do
    url "https://github.com/juju/replicaset.git",
        :revision => "a5137dd3d7a1495ef2dd32cfbac616654913cf49"
  end
  go_resource "github.com/juju/schema" do
    url "https://github.com/juju/schema.git",
        :revision => "1c4e902df91bd058b84029533bf4ce92e6ef87ab"
  end
  go_resource "github.com/juju/syslog" do
    url "https://github.com/juju/syslog.git",
        :revision => "6be94e8b718766e9ff7a37342157fe4795da7cfa"
  end
  go_resource "github.com/juju/testing" do
    url "https://github.com/juju/testing.git",
        :revision => "a3720f880a5787622a21fbf718a3ac9d551dbe9c"
  end
  go_resource "github.com/juju/txn" do
    url "https://github.com/juju/txn.git",
        :revision => "2407a1fa094db5603f4718f11e1fafc8543273eb"
  end
  go_resource "github.com/juju/utils" do
    url "https://github.com/juju/utils.git",
        :revision => "74de2af2d82f17a3e8d12c9aa50af256c9a74ab9"
  end
  go_resource "github.com/juju/xml" do
    url "https://github.com/juju/xml.git",
        :revision => "eb759a627588d35166bc505fceb51b88500e291e"
  end
  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto",
        :using => :git,
        :revision => "c57d4a71915a248dbad846d60825145062b4c18e"
  end
  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net",
        :using => :git,
        :revision => "7dbad50ab5b31073856416cdcfeb2796d682f844"
  end
  go_resource "golang.org/x/oauth2" do
    url "https://go.googlesource.com/oauth2",
        :using => :git,
        :revision => "11c60b6f71a6ad48ed6f93c65fa4c6f9b1b5b46a"
  end
  go_resource "google.golang.org/api" do
    url "https://github.com/google/google-api-go-client.git",
        :revision => "b80bb08538855e6efebabd0df2dc2d8cf46cc2db"
  end
  go_resource "google.golang.org/cloud" do
    url "https://github.com/GoogleCloudPlatform/gcloud-golang.git",
        :revision => "ae54c7850096ec392a6694d6955f9456487dd0b5"
  end
  go_resource "gopkg.in/amz.v3" do
    url "https://github.com/go-amz/amz.git",
        :branch => "v3",
        :revision => "f5c958d2b012da23a4600bad441f20b13ec262c4"
  end
  go_resource "gopkg.in/check.v1" do
    url "https://github.com/go-check/check.git",
        :branch => "v1",
        :revision => "64131543e7896d5bcc6bd5a76287eb75ea96c673"
  end
  go_resource "gopkg.in/errgo.v1" do
    url "https://github.com/go-errgo/errgo.git",
        :branch => "v1",
        :revision => "81357a83344ddd9f7772884874e5622c2a3da21c"
  end
  go_resource "gopkg.in/juju/charm.v5" do
    url "https://github.com/juju/charm.git",
        :branch => "v5",
        :revision => "6b74a2771545912f8a91a544b0f28405b9938624"
  end
  go_resource "gopkg.in/juju/charmstore.v4" do
    url "https://github.com/juju/charmstore.git",
        :branch => "v4",
        :revision => "ab64d50370f9c167a7cd55be8ea22c3842aae46d"
  end
  go_resource "gopkg.in/macaroon-bakery.v0" do
    url "https://github.com/go-macaroon-bakery/macaroon-bakery.git",
        :branch => "v0",
        :revision => "9593b80b01ba04b519769d045dffd6abd827d2fd"
  end
  go_resource "gopkg.in/macaroon.v1" do
    url "https://github.com/go-macaroon/macaroon.git",
        :branch => "v1",
        :revision => "ab3940c6c16510a850e1c2dd628b919f0f3f1464"
  end
  go_resource "gopkg.in/mgo.v2" do
    url "https://github.com/go-mgo/mgo.git",
        :branch => "v2",
        :revision => "dc255bb679efa273b6544a03261c4053505498a4"
  end
  go_resource "gopkg.in/natefinch/lumberjack.v2" do
    url "https://github.com/natefinch/lumberjack.git",
        :branch => "v2.0",
        :revision => "d28785c2f27cd682d872df46ccd8232843629f54"
  end
  go_resource "gopkg.in/natefinch/npipe.v2" do
    url "https://github.com/natefinch/npipe.git",
        :branch => "v2",
        :revision => "e562d4ae5c2f838f9e7e406f7d9890d5b02467a9"
  end
  go_resource "gopkg.in/yaml.v1" do
    url "https://github.com/go-yaml/yaml.git",
        :branch => "v1",
        :revision => "9f9df34309c04878acc86042b16630b0f696e1de"
  end
  go_resource "launchpad.net/gnuflag" do
    url "lp:gnuflag",
        :using => :bzr,
        :revision => "roger.peppe@canonical.com-20140716064605-pk32dnmfust02yab"
  end
  go_resource "launchpad.net/golxc" do
    url "lp:golxc",
        :using => :bzr,
        :revision => "ian.booth@canonical.com-20141121040613-ztm1q0iy9rune3zt"
  end
  go_resource "launchpad.net/gomaasapi" do
    url "lp:gomaasapi",
        :using => :bzr,
        :revision => "ian.booth@canonical.com-20150113032002-n7hj4l5a9j9dzaa0"
  end
  go_resource "launchpad.net/goose" do
    url "lp:goose",
        :using => :bzr,
        :revision => "tarmac-20140908075634-5iinsru19k3d8w55"
  end
  go_resource "launchpad.net/gwacl" do
    url "lp:gwacl",
        :using => :bzr,
        :revision => "andrew.wilkins@canonical.com-20141203072923-27pcp2hckqyezbfe"
  end
  go_resource "launchpad.net/tomb" do
    url "lp:tomb",
        :using => :bzr,
        :revision => "gustavo@niemeyer.net-20130531003818-70ikdgklbxopn8x4"
  end

  # dependencies of dependencies
  go_resource "launchpad.net/gocheck" do
    url "https://github.com/go-check/check.git",
        :revision => "64131543e7896d5bcc6bd5a76287eb75ea96c673"
  end
  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "e228b1ac337584c4ce21b022312332ca6a5532ff"
  end
  go_resource "google.golang.org/appengine" do
    url "https://github.com/golang/appengine.git",
        :revision => "0867183215f0e9a27cb9558dd4efd17ff55e75ba"
  end
  go_resource "code.google.com/p/goauth2" do
    url "https://code.google.com/p/goauth2/",
        :using => :hg, :revision => "afe77d958c70"
  end
  go_resource "golang.org/x/text" do
    url "https://github.com/golang/text.git",
        :revision => "af4c2d73d0954e6f7ed1bd89afe33c9d347d9be5"
  end

  def install
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/juju/"
    ln_sf buildpath, buildpath/"src/github.com/juju/juju"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", bin/"juju", "-v",
           "./src/github.com/juju/juju/cmd/juju"

    system "go", "build", "-o", bin/"jujud", "-v",
           "./src/github.com/juju/juju/cmd/jujud"

    system "go", "build", "-o", bin/"juju-metadata", "-v",
           "./src/github.com/juju/juju/cmd/plugins/juju-metadata"

    system "go", "build", "-o", bin/"juju-restore", "-v",
           "./src/github.com/juju/juju/cmd/plugins/juju-restore"

    bin.install "./src/github.com/juju/juju/cmd/plugins/juju-backup/juju-backup"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system bin/"juju", "init"
    File.exist? testpath/".juju/environments.yaml"
  end
end
