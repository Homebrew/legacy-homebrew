require "language/go"

class Acmetool < Formula
  desc "Automatic certificate acquisition tool for ACME (Let's Encrypt)"
  homepage "https://github.com/hlandau/acme"
  url "https://github.com/hlandau/acme/archive/v0.0.49.tar.gz"
  sha256 "2132c5e461d0be85932365da28f12a2fef0f820e0674200b91c48dcf1f49c56b"

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
      :revision => "7b2428fec40033549c68f54e26e89e7ca9a9ce31"
  end

  go_resource "github.com/hlandau/degoutils" do
    url "https://github.com/hlandau/degoutils.git",
      :revision => "16c74ccb617a3a6c45ff5631cb4679d10b20ad2c"
  end

  go_resource "github.com/hlandau/xlog" do
    url "https://github.com/hlandau/xlog.git",
      :revision => "c18de5703f79e62275a7282dc8979ff6c2d5f7d8"
  end

  go_resource "github.com/hlandauf/gspt" do
    url "https://github.com/hlandauf/gspt.git",
      :revision => "25f3bd3f5948489aa5f31c949310ae9f2b0e956c"
  end

  go_resource "github.com/hlandauf/pb" do
    url "https://github.com/hlandauf/pb.git",
      :revision => "0c1cdefd84b3b1937c4e54309f3a817d9c683bab"
  end

  go_resource "github.com/jmhodges/clock" do
    url "https://github.com/jmhodges/clock.git",
      :revision => "3c4ebd218625c9364c33db6d39c276d80c3090c6"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
      :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mitchellh/go-wordwrap" do
    url "https://github.com/mitchellh/go-wordwrap.git",
      :revision => "ad45545899c7b13c020ea92b2072220eefad42b8"
  end

  go_resource "github.com/ogier/pflag" do
    url "https://github.com/ogier/pflag.git",
      :revision => "45c278ab3607870051a2ea9040bb85fcb8557481"
  end

  go_resource "github.com/peterhellberg/link" do
    url "https://github.com/peterhellberg/link.git",
      :revision => "1053d3b2893eeebd482fce32550ec24bebed308c"
  end

  go_resource "github.com/satori/go.uuid" do
    url "https://github.com/satori/go.uuid.git",
      :revision => "e673fdd4dea8a7334adbbe7f57b7e4b00bdc5502"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
      :revision => "a422bbe96644373c5753384a59d678f7d261ff10"
  end

  go_resource "github.com/square/go-jose" do
    url "https://github.com/square/go-jose.git",
      :revision => "7465d2baefd097ef32054b46be7d9c41185869a1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
      :revision => "5dc8cb4b8a8eb076cbb5a06bc3b8682c15bdbbd3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
      :revision => "3e5cd1ed149001198e582f9d3f5bfd564cde2896"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    url "https://gopkg.in/alecthomas/kingpin.v2.git",
      :revision => "8cccfa8eb2e3183254457fb1749b2667fbc364c7"
  end

  go_resource "gopkg.in/hlandau/configurable.v1" do
    url "https://gopkg.in/hlandau/configurable.v1.git",
      :revision => "41496864a1fe3e0fef2973f22372b755d2897402"
  end

  go_resource "gopkg.in/hlandau/easyconfig.v1" do
    url "https://gopkg.in/hlandau/easyconfig.v1.git",
      :revision => "f38184c467a3200c92ac929527daf77497b7ec69"
  end

  go_resource "gopkg.in/hlandau/service.v2" do
    url "https://gopkg.in/hlandau/service.v2.git",
      :revision => "601cce2a79c1e61856e27f43c28ed4d7d2c7a619"
  end

  go_resource "gopkg.in/hlandau/svcutils.v1" do
    url "https://gopkg.in/hlandau/svcutils.v1.git",
      :revision => "09c5458e23bda3b8e4d925fd587bd44fbdb5950e"
  end

  go_resource "gopkg.in/tylerb/graceful.v1" do
    url "https://gopkg.in/tylerb/graceful.v1.git",
      :revision => "119c58e176bce26fd40698146d9a106c8f1723a5"
  end

  go_resource "gopkg.in/yaml.v2" do
    url "https://gopkg.in/yaml.v2.git",
      :revision => "a83829b6f1293c91addabc89d0571c246397bbf4"
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
