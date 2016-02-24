require "language/go"

class Consul < Formula
  desc "Tool for service discovery, monitoring and configuration"
  homepage "https://www.consul.io"
  url "https://github.com/hashicorp/consul.git",
    :tag => "v0.6.3", :revision => "c933efde50d25395c7b5a42167578fda603d43d8"

  head "https://github.com/hashicorp/consul.git", :shallow => false

  bottle do
    cellar :any_skip_relocation
    sha256 "68f49f7a77ecf9008e2d07e957b530392c57f5c0765c0caf3e2b5b623f6c291a" => :el_capitan
    sha256 "6d10d26c6cef0ab909ba1fb7285259b4b045c50f02f46cf56bb6393c45af70c8" => :yosemite
    sha256 "edc112792bdc15448c9ff102e2234eee0ca544d11c85f9a949a74719338bc535" => :mavericks
  end

  option "with-web-ui", "Installs the consul web ui"

  depends_on "go" => :build

  go_resource "github.com/DataDog/datadog-go" do
    url "https://github.com/DataDog/datadog-go.git",
      :revision => "bc97e0770ad4edae1c9dc14beb40b79b2dde32f8"
  end

  go_resource "github.com/armon/circbuf" do
    url "https://github.com/armon/circbuf.git",
      :revision => "bbbad097214e2918d8543d5201d12bfd7bca254d"
  end

  go_resource "github.com/armon/go-metrics" do
    url "https://github.com/armon/go-metrics.git",
      :revision => "345426c77237ece5dab0e1605c3e4b35c3f54757"
  end

  go_resource "github.com/armon/go-radix" do
    url "https://github.com/armon/go-radix.git",
      :revision => "4239b77079c7b5d1243b7b4736304ce8ddb6f0f2"
  end

  go_resource "github.com/boltdb/bolt" do
    url "https://github.com/boltdb/bolt.git",
      :revision => "ee4a0888a9abe7eefe5a0992ca4cb06864839873"
  end

  go_resource "github.com/fsouza/go-dockerclient" do
    url "https://github.com/fsouza/go-dockerclient.git",
      :revision => "25bc220b299845ae5489fd19bf89c5278864b050"
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
      :revision => "ce617e79981a8fff618bb643d155133a8f38db96"
  end

  go_resource "github.com/hashicorp/go-immutable-radix" do
    url "https://github.com/hashicorp/go-immutable-radix.git",
      :revision => "12e90058b2897552deea141eff51bb7a07a09e63"
  end

  go_resource "github.com/hashicorp/go-memdb" do
    url "https://github.com/hashicorp/go-memdb.git",
      :revision => "31949d523ade8a236956c6f1761e9dcf902d1638"
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
      :revision => "5c7531c003d8bf158b0fe5063649a2f41a822146"
  end

  go_resource "github.com/hashicorp/hcl" do
    url "https://github.com/hashicorp/hcl.git",
      :revision => "578dd9746824a54637686b51a41bad457a56bcef"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
      :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/memberlist" do
    url "https://github.com/hashicorp/memberlist.git",
      :revision => "9888dc523910e5d22c5be4f6e34520943df21809"
  end

  go_resource "github.com/hashicorp/net-rpc-msgpackrpc" do
    url "https://github.com/hashicorp/net-rpc-msgpackrpc.git",
      :revision => "a14192a58a694c123d8fe5481d4a4727d6ae82f3"
  end

  go_resource "github.com/hashicorp/raft" do
    url "https://github.com/hashicorp/raft.git",
      :revision => "057b893fd996696719e98b6c44649ea14968c811"
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
      :revision => "64d10e9428bd70dbcd831ad087573b66731c014b"
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
      :revision => "c144371d31e35dc0588755ada496462c102c90a6"
  end

  go_resource "github.com/mitchellh/cli" do
    url "https://github.com/mitchellh/cli.git",
      :revision => "cb6853d606ea4a12a15ac83cc43503df99fd28fb"
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
      :revision => "3760e016850398b85094c4c99e955b8c3dea5711"
  end

  resource "web-ui" do
    url "https://releases.hashicorp.com/consul/0.6.3/consul_0.6.3_web_ui.zip"
    sha256 "93bbb300cacfe8de90fb3bd5ede7d37ae6ce014898edc520b9c96a676b2bbb72"
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
