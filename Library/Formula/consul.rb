require "language/go"

class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
    :tag => "v0.5.2", :revision => "9a9cc9341bb487651a0399e3fc5e1e8a42e62dd9"

  bottle do
    cellar :any
    sha256 "a77fef3fc07e7b00f17f93a30361edfdb1351b411506538dad8697cffc5f59f4" => :yosemite
    sha256 "eb6ae6959dfaac6250bf78d2e7c0658c165e4098e80ec8142edba27920d6d8f9" => :mavericks
    sha256 "67052157266d536598ba7eb5af31a10fd3e609ca812be6d50869d0fe80a583f9" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git",
      :revision => "f092b4f207b6e5cce0569056fba9e1a2735cb6cf"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
      :revision => "b2d95e5291cdbc26997d1301a5e467ecbb240e25"
  end

  go_resource "github.com/armon/go-radix" do
    url "https://github.com/armon/go-radix.git",
      :revision => "fbd82e84e2b13651f3abc5ffd26b65ba71bc8f93"
  end

  go_resource "github.com/armon/gomdb" do
    url "https://github.com/armon/gomdb.git",
      :revision => "151f2e08ef45cb0e57d694b2562f351955dff572"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "04a3e85793043e76d41164037d0d7f9d53eecae3"
  end

  go_resource "github.com/hashicorp/consul-migrate" do
    url "https://github.com/hashicorp/consul-migrate.git",
      :revision => "678fb10cdeae25ab309e99e655148f0bf65f9710"
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

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
      :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/hashicorp/golang-lru" do
    url "https://github.com/hashicorp/golang-lru.git",
      :revision => "7f9ef20a0256f494e24126014135cf893ab71e9e"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "54864211433d45cb780682431585b3e573b49e4a"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
      :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/memberlist" do
    url "https://github.com/hashicorp/memberlist.git",
      :revision => "3636f9694d601b5f68da11676d59cdf8a4c9dfe3"
  end

  go_resource "github.com/hashicorp/net-rpc-msgpackrpc" do
    url "https://github.com/hashicorp/net-rpc-msgpackrpc.git",
      :revision => "d377902b7aba83dd3895837b902f6cf3f71edcb2"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
      :revision => "53ca2ec750f09e888a0c051e7c68c98246176be2"
  end

  go_resource "github.com/hashicorp/raft-boltdb" do
    url "https://github.com/hashicorp/raft-boltdb.git",
      :revision => "d1e82c1ec3f15ee991f7cc7ffd5b67ff6f5bbaee"
  end

  go_resource "github.com/hashicorp/raft-mdb" do
    url "https://github.com/hashicorp/raft-mdb.git",
      :revision => "4ec3694ffbc74d34f7532e70ef2e9c3546a0c0b0"
  end

  go_resource "github.com/hashicorp/scada-client" do
    url "https://github.com/hashicorp/scada-client.git",
      :revision => "c26580cfe35393f6f4bf1b9ba55e6afe33176bae"
  end

  go_resource "github.com/hashicorp/serf" do
    url "https://github.com/hashicorp/serf.git",
      :revision => "932865ce77ba6ab0ebf5978040f8b23825762d44"
  end

  go_resource "github.com/hashicorp/yamux" do
    url "https://github.com/hashicorp/yamux.git",
      :revision => "8e00b30457b1486b012f204b82ec92ae6b547de8"
  end

  go_resource "github.com/inconshreveable/muxado" do
    url "https://github.com/inconshreveable/muxado.git",
      :revision => "f693c7e88ba316d1a0ae3e205e22a01aa3ec2848"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
      :revision => "3e549e2f6fd420cdffa528144b925305401bf55c"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "8102d0ed5ea2709ade1243798785888175f6e415"
  end

  go_resource "github.com/mitchellh/mapstructure" do
    url "https://github.com/mitchellh/mapstructure.git",
      :revision => "2caf8efc93669b6c43e0441cdc6aed17546c96f3"
  end

  go_resource "github.com/ryanuber/columnize" do
    url "https://github.com/ryanuber/columnize.git",
      :revision => "44cb4788b2ec3c3d158dd3d1b50aba7d66f4b59a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "f6a608df624ae17d57958a8a294c66da81730577"
  end

  def install
    ENV["GOPATH"] = buildpath

    consulpath = buildpath/"src/github.com/hashicorp/consul"
    consulpath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    # build gomdb separately to avoid linker errors
    cd "src/github.com/armon/gomdb" do
      system "go", "install"
    end

    cd "src/github.com/hashicorp/consul" do
      system "make"
      bin.install "bin/consul"
    end
  end

  test do
    fork do
      exec "#{bin}/consul", "agent", "-data-dir", "."
    end
    sleep 3
    system "#{bin}/consul", "leave"
  end
end
