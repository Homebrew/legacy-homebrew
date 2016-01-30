require "language/go"

class Serf < Formula
  desc "Service orchestration and management tool"
  homepage "https://serfdom.io/"
  url "https://github.com/hashicorp/serf.git",
      :tag => "v0.7.0",
      :revision => "0df3e3df1703f838243a7f3f12bf0b88566ade5a"

  head "https://github.com/hashicorp/serf.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "c99e19fe8612c47714fb4708786257e18a37ef4b9f1292d696d64a68f799fb71" => :el_capitan
    sha256 "d3c23ca2f9fb755253ac6fb2f084852fd2d63c93ddca4a0aef43b09325ce65f9" => :yosemite
    sha256 "838e49a15d4ffad8f4e2b302e6da1454a470031b4f433a65d465878b477fc0f4" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/iochan" do
    url "https://github.com/mitchellh/iochan.git",
        :revision => "87b45ffd0e9581375c491fef3d32130bb15c5bd7"
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

  go_resource "github.com/bgentry/speakeasy" do
    url "https://github.com/bgentry/speakeasy.git",
      :revision => "36e9cfdd690967f4f690c6edcc9ffacd006014a0"
  end

  go_resource "github.com/hashicorp/go-msgpack" do
    url "https://github.com/hashicorp/go-msgpack.git",
      :revision => "fa3f63826f7c23912c15263591e65d54d080b458"
  end

  go_resource "github.com/hashicorp/go-syslog" do
    url "https://github.com/hashicorp/go-syslog.git",
      :revision => "42a2b573b664dbf281bd48c3cc12c086b17a39ba"
  end

  go_resource "github.com/hashicorp/go.net" do
    url "https://github.com/hashicorp/go.net.git",
      :revision => "104dcad90073cd8d1e6828b2af19185b60cf3e29"
  end

  go_resource "github.com/hashicorp/logutils" do
    url "https://github.com/hashicorp/logutils.git",
      :revision => "0dc08b1671f34c4250ce212759ebd880f743d883"
  end

  go_resource "github.com/hashicorp/mdns" do
    url "https://github.com/hashicorp/mdns.git",
      :revision => "9d85cf22f9f8d53cb5c81c1b2749f438b2ee333f"
  end

  go_resource "github.com/hashicorp/memberlist" do
    url "https://github.com/hashicorp/memberlist.git",
      :revision => "9888dc523910e5d22c5be4f6e34520943df21809"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
      :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/miekg/dns" do
    url "https://github.com/miekg/dns.git",
      :revision => "4687536c727745d43759e8baae72cccf716f813a"
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

  def install
    contents = Dir["*"]
    gopath = buildpath/"gopath"
    (gopath/"src/github.com/hashicorp/serf").install contents

    ENV["GOPATH"] = gopath
    arch = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["XC_ARCH"] = arch
    ENV["XC_OS"] = "darwin"
    ENV.prepend_create_path "PATH", gopath/"bin"

    Language::Go.stage_deps resources, gopath/"src"

    cd gopath/"src/github.com/hashicorp/serf" do
      system "make", "bin"
      bin.install "bin/serf"
    end
  end

  test do
    begin
      pid = fork do
        exec "#{bin}/serf", "agent"
      end
      sleep 1
      assert_match /:7946.*alive$/, shell_output("#{bin}/serf members")
    ensure
      system "#{bin}/serf", "leave"
      Process.kill "SIGINT", pid
      Process.wait pid
    end
  end
end
