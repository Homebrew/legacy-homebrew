require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme/archive/v0.0.34.tar.gz"
  sha256 "f6f4ea05d1852a1a554cc03c6305108bf16ddba52e31a90bb2e6bc3ab59c2f80"
  revision 1

  bottle do
    sha256 "e2373472823865a9431751510448413bf0ca7d95edb6331cc684c442f6a25983" => :el_capitan
    sha256 "0f468c46517f1b23faf4b4a447bf85eb0da1af7dd3680fd3542a23a09340cd6f" => :yosemite
    sha256 "f25e1ab3e9beb77c61fbb17e4349b87b5e2039bb4cbff32ef1152487cae31ea1" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
      :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
      :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "github.com/coreos/go-systemd" do
    url "https://github.com/coreos/go-systemd.git",
      :revision => "4f14f6deef2da87e4aa59e6c1c1f3e02ba44c5e1"
  end

  go_resource "github.com/hlandau/degoutils" do
    url "https://github.com/hlandau/degoutils.git",
      :revision => "506416d2acb230b3227a5cc2c4f19dd5f376b2bd"
  end

  go_resource "github.com/hlandau/xlog" do
    url "https://github.com/hlandau/xlog.git",
      :revision => "c37f75515760879c01260fdb842000f8af5c665c"
  end

  go_resource "github.com/hlandauf/gspt" do
    url "https://github.com/hlandauf/gspt.git",
      :revision => "25f3bd3f5948489aa5f31c949310ae9f2b0e956c"
  end

  go_resource "github.com/hlandauf/pb" do
    url "https://github.com/hlandauf/pb.git",
      :revision => "0c1cdefd84b3b1937c4e54309f3a817d9c683bab"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
      :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/ogier/pflag" do
    url "https://github.com/ogier/pflag.git",
      :revision => "6f7159c3154e7cd4ab30f6cc9c58fa3fd0f22325"
  end

  go_resource "github.com/peterhellberg/link" do
    url "https://github.com/peterhellberg/link.git",
      :revision => "1053d3b2893eeebd482fce32550ec24bebed308c"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "d41af8bb6a7704f00bc3b7cba9355ae6a5a80048"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
      :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "github.com/square/go-jose" do
    url "https://github.com/square/go-jose.git",
      :revision => "37934a899dd03635373fd1e143936d32cfe48d31"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "f23ba3a5ee43012fcb4b92e1a2a405a92554f4f2"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "f1d3149ecb40ffadf4a28d39a30f9a125fe57bdf"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
      :revision => "8852570bd3865e9c4d4cb7cf5001c4295b07cad5"
  end

  go_resource "gopkg.in/hlandau/configurable.v1" do
    url "https://gopkg.in/hlandau/configurable.v1.git",
      :revision => "41496864a1fe3e0fef2973f22372b755d2897402"
  end

  go_resource "gopkg.in/hlandau/easyconfig.v1" do
    url "https://gopkg.in/hlandau/easyconfig.v1.git",
      :revision => "c54c1752c0585f34484ae2f218366984d2234ede"
  end

  go_resource "gopkg.in/hlandau/service.v2" do
    url "https://gopkg.in/hlandau/service.v2.git",
      :revision => "88289e1ff32ad5b17c5b19d3d9680af98b036d0d"
  end

  go_resource "gopkg.in/hlandau/svcutils.v1" do
    url "https://gopkg.in/hlandau/svcutils.v1.git",
      :revision => "71059456e8e64b0913a61a46dd1898853222905e"
  end

  go_resource "gopkg.in/tylerb/graceful.v1" do
    url "https://gopkg.in/tylerb/graceful.v1.git",
      :revision => "48afeb21e2fcbcff0f30bd5ad6b97747b0fae38e"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "53feefa2559fb8dfa8d81baad31be332c97d6c77"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/hlandau/"
    ln_sf buildpath, buildpath/"src/github.com/hlandau/acme"
    Language::Go.stage_deps resources, buildpath/"src"

    # https://github.com/hlandau/acme/blob/master/_doc/PACKAGING-PATHS.md
    builddate = `date -u "+%Y%m%d%H%M%S"`.strip
    ldflags = <<-LDFLAGS
        -X github.com/hlandau/acme/storage.RecommendedPath=#{var}/lib/acmetool
        -X github.com/hlandau/acme/notify.DefaultHookPath=#{lib}/hooks
        -X github.com/hlandau/acme/responder.StandardWebrootPath=#{var}/run/acmetool/acme-challenge
        -X github.com/hlandau/degoutils/buildinfo.BuildInfo=v#{version}-#{builddate}-Homebrew
    LDFLAGS

    system "go", "build", "-o", bin/"acmetool", "-ldflags", ldflags,
        "github.com/hlandau/acme/cmd/acmetool"

    system "#{bin}/acmetool --help-man >> acmetool.8"
    man8.install "acmetool.8"

    doc.install "README.md", Dir["_doc/*"]
  end

  def post_install
    (var/"lib/acmetool").mkpath
    (var/"run/acmetool").mkpath
  end

  test do
    system "#{bin}/acmetool", "help"
  end
end
