require "language/go"

class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
    :tag => "v0.6.0", :revision => "46499d6e7237ca8547c15ce44e9b93bea48a455b"

  bottle do
    cellar :any_skip_relocation
    sha256 "00846640d99db5b0cedee6432201dff081b1d5b50459cc31ab118c439bd5d648" => :el_capitan
    sha256 "525c303e6000e59dc04c6610fd081825306aed932be27e1a053b8e536808ca87" => :yosemite
    sha256 "c8944ce4f9c2542447e1968a72585411f06662e9c43c6ad54bbac554edab5826" => :mavericks
  end

  option "with-web-ui", "Installs the consul web ui"

  depends_on "go" => :build

  go_resource "github.com/DataDog/datadog-go" do
    url "https://github.com/DataDog/datadog-go.git",
      :revision => "b050cd8f4d7c394545fd7d966c8e2909ce89d552"
  end

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git",
      :revision => "bbbad097214e2918d8543d5201d12bfd7bca254d"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
      :revision => "6c5fa0d8f48f4661c9ba8709799c88d425ad20f0"
  end

  go_resource "github.com/armon/go-radix" do
    url "https://github.com/armon/go-radix.git",
      :revision => "fbd82e84e2b13651f3abc5ffd26b65ba71bc8f93"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "0b00effdd7a8270ebd91c24297e51643e370dd52"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
      :revision => "2350d7bc12bb04f2d7d6824c7718012b1397b760"
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

  go_resource "github.com/hashicorp/go-immutable-radix" do
    url "https://github.com/hashicorp/go-immutable-radix.git",
      :revision => "aca1bd0689e10884f20d114aff148ddb849ece80"
  end

  go_resource "github.com/hashicorp/go-memdb" do
    url "https://github.com/hashicorp/go-memdb.git",
      :revision => "9ea975be0e31ada034a5760340d4892f3f543d20"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/go-multierror" do
    url "https://github.com/hashicorp/go-multierror.git",
      :revision => "d30f09973e19c1dfcd120b2d9c4f168e68d6b5d5"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
      :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/hashicorp/golang-lru" do
    url "https://github.com/hashicorp/golang-lru.git",
      :revision => "a6091bb5d00e2e9c4a16a0e739e306f8a3071a3c"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "2deb1d1db27ed473f38fe65a16044572b9ff9d30"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
      :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/memberlist" do
    url "https://github.com/hashicorp/memberlist.git",
      :revision => "28424fb38c7c3e30f366b72b1a55f690d318d8f3"
  end

  go_resource "github.com/hashicorp/net-rpc-msgpackrpc" do
    url "https://github.com/hashicorp/net-rpc-msgpackrpc.git",
      :revision => "a14192a58a694c123d8fe5481d4a4727d6ae82f3"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
      :revision => "d136cd15dfb7876fd7c89cad1995bc4f19ceb294"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git",
      :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/hashicorp/scada-client" do
    url "https://github.com/hashicorp/scada-client.git",
      :revision => "84989fd23ad4cc0e7ad44d6a871fd793eb9beb0a"
  end

  go_resource "github.com/hashicorp/serf" do
    url "https://github.com/hashicorp/serf.git",
      :revision => "a72c0453da2ba628a013e98bf323a76be4aa1443"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "df949784da9ed028ee76df44652e42d37a09d7e4"
  end

  go_resource "github.com/inconshreveable/muxado" do
    url "https://github.com/inconshreveable/muxado.git",
      :revision => "f693c7e88ba316d1a0ae3e205e22a01aa3ec2848"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
      :revision => "d27455715200c7d3e321a1e5cadb27c9ee0b0f02"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "8102d0ed5ea2709ade1243798785888175f6e415"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "281073eb9eb092240d33ef253c404f1cca550309"
  end

  go_resource "github.com/ryanuber/columnize" do
    url "https://github.com/ryanuber/columnize.git",
      :revision => "983d3a5fab1bf04d1b412465d2d9f8430e2e917e"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "346896d57731cb5670b36c6178fc5519f3225980"
  end

  resource "web-ui" do
    url "https://releases.hashicorp.com/consul/0.6.0/consul_0.6.0_web_ui.zip"
    sha256 "73c5e7ee50bb4a2efe56331d330e6d7dbf46335599c028344ccc4031c0c32eb0"
  end

  def install
    contents = Dir["{*,.git,.gitignore}"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/consul").install contents

    ENV["GOPATH"] = gopath
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
    end

    # install web-ui to package share folder.
    (pkgshare/"web-ui").install resource("web-ui") if build.with? "web-ui"
  end

  def caveats; <<-EOS.undent
    If consul was built with --with-web-ui, you can activate the UI by running
    consul with `-ui-dir #{pkgshare}/web-ui`.
    EOS
  end

  test do
    fork do
      exec "#{bin}/consul", "agent", "-data-dir", "."
    end
    sleep 3
    system "#{bin}/consul", "leave"
  end
end
