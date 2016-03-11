require "language/go"

class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.4.tar.gz"
  sha256 "8cf15ece9b707658ef4825e4c031ff8dd54b8ea7c4ff6a9b07bb68b400d15253"

  bottle do
    cellar :any_skip_relocation
    sha256 "c72f8f42362c8cad2f6c50046094bf31fdc608041bccd7bdf37617d94848f067" => :el_capitan
    sha256 "2ce3f638ae9ad4c857d55ea339a06bf6dcd9785587f4cf64e1aa6b840b78ef76" => :yosemite
    sha256 "fcb262017bd92e849b441064c11fc6296cbe06fff9dae00957ec336e231d7e3c" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/GeertJohan/go.rice" do
    url "https://github.com/GeertJohan/go.rice.git",
        :revision => "0f3f5fde32fd1f755632a3d31ba2ec6d449e387b"
  end

  # go.rice dependencies
  go_resource "github.com/daaku/go.zipexe" do
    url "https://github.com/daaku/go.zipexe.git",
        :revision => "a5fe2436ffcb3236e175e5149162b41cd28bd27d"
  end

  go_resource "github.com/GeertJohan/go.incremental" do
    url "https://github.com/GeertJohan/go.incremental.git",
        :revision => "92fd0ce4a694213e8b3dfd2d39b16e51d26d0fbf"
  end

  go_resource "github.com/akavel/rsrc" do
    url "https://github.com/akavel/rsrc.git",
        :revision => "ba14da1f827188454a4591717fff29999010887f"
  end

  go_resource "github.com/jessevdk/go-flags" do
    url "https://github.com/jessevdk/go-flags.git",
        :revision => "6b9493b3cb60367edd942144879646604089e3f7"
  end

  # devd dependencies
  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "29ae4ffbc9a6fe9fb2bc5029050ce6996ea1d3bc"
  end

  go_resource "github.com/bmatcuk/doublestar" do
    # v1.0.3
    url "https://github.com/bmatcuk/doublestar.git",
        :revision => "ec3b4af762f792cb93bf2518ff9ac408dbdc2b4e"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "8929fe90cee4b2cb9deb468b51fb34eba64d1bf0"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "4f7bcef27eec7925456d0c30c5e7b0408b3339be"
  end

  go_resource "github.com/goji/httpauth" do
    url "https://github.com/goji/httpauth.git",
        :revision => "fc389c3003535723411032f2e9300889389e30fa"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "5c91b59efa232fa9a87b705d54101832c498a172"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "77ed1c8a01217656d2080ad51981f6e99adaa177"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "d682a8f0cf139663a984ff12528da460ca963de9"
  end

  go_resource "github.com/rjeczalik/notify" do
    url "https://github.com/rjeczalik/notify.git",
        :revision => "efbcb15a545abd0c7d546f0a15f4115c713a4c59"
  end

  go_resource "github.com/toqueteos/webbrowser" do
    # v1.0
    url "https://github.com/toqueteos/webbrowser.git",
        :revision => "21fc9f95c83442fd164094666f7cb4f9fdd56cd6"
  end

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
        :revision => "14fd436dd20c3cc65242a9f396b61bfc8a3926fc"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
        :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "5dc8cb4b8a8eb076cbb5a06bc3b8682c15bdbbd3"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "6acef71eb69611914f7a30939ea9f6e194c78172"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    # v2.1.11
    url "https://github.com/alecthomas/kingpin.git",
        :revision => "8cccfa8eb2e3183254457fb1749b2667fbc364c7"
  end

  go_resource "github.com/cortesi/modd" do
    # v0.2
    url "https://github.com/cortesi/modd.git",
        :revision => "459621750bfdbd0a80d706db8092d4b3a34a55d6"
  end

  go_resource "github.com/cortesi/termlog" do
    url "https://github.com/cortesi/termlog.git",
        :revision => "898fe0decfa430637283eebf1fd19d4f6ce0a531"
  end

  def install
    ENV["GOOS"] = "darwin"
    ENV["GOARCH"] = MacOS.prefer_64_bit? ? "amd64" : "386"
    ENV["GOPATH"] = buildpath

    mkdir_p buildpath/"src/github.com/cortesi/"
    ln_sf buildpath, buildpath/"src/github.com/cortesi/devd"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "install", "github.com/GeertJohan/go.rice/rice"

    ENV.prepend_path "PATH", buildpath/"bin"

    # NOTE: versions after v0.3 have improved build script, thus
    # it would be simplier to call in future
    # system "./build", "single"
    # meanwhile, we do compilation like this:
    system "rice", "embed-go"
    cd "#{buildpath}/livereload" do
      system "rice", "embed-go"
    end
    system "go", "build", "-o", "#{bin}/devd", "./cmd/devd"
    doc.install "README.md"
  end

  test do
    begin
      io = IO.popen("#{bin}/devd #{testpath}")
      sleep 2
    ensure
      Process.kill("SIGINT", io.pid)
      Process.wait(io.pid)
    end

    assert_match "Listening on http://devd.io", io.read
  end
end
