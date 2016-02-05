require "language/go"

class Devd < Formula
  desc "Local webserver for developers"
  homepage "https://github.com/cortesi/devd"
  url "https://github.com/cortesi/devd/archive/v0.3.tar.gz"
  sha256 "e806421a4de6572eb3196b215a86a3b72bcd0f5a12956224d191e47663f9c4ab"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "3b7c357c44ec47b77d5ad89ff929b38447cb87b1b5698e0efa1d558cb22c7b26" => :el_capitan
    sha256 "3a91f99b6136a401cd5551d0ed2c06e100bb80e7a844478096fff9ee944934b3" => :yosemite
    sha256 "6e160b2d36c713c3dce3342f30c7ea2e81b6ec449719e01781c4ca5b21bf3e9e" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/GeertJohan/go.rice" do
    url "https://github.com/GeertJohan/go.rice.git",
        :revision => "ada95a01c963696fb73320ee662195af68be81ae"
  end

  # go.rice dependencies
  go_resource "github.com/daaku/go.zipexe" do
    url "https://github.com/daaku/go.zipexe.git",
        :revision => "a5fe2436ffcb3236e175e5149162b41cd28bd27d"
  end

  go_resource "github.com/kardianos/osext" do
    url "https://github.com/kardianos/osext.git",
        :revision => "6e7f843663477789fac7c02def0d0909e969b4e5"
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
        :revision => "fc93116606d0a71d7e9de0ad5734fdb4b8eae834"
  end

  # devd dependencies
  go_resource "github.com/bmatcuk/doublestar" do
    # v1.0.1
    url "https://github.com/bmatcuk/doublestar.git",
        :revision => "4f612bd6c10e2ef68e2ea50aabc50c3681bbac86"
  end

  go_resource "github.com/dustin/go-humanize" do
    url "https://github.com/dustin/go-humanize.git",
        :revision => "64dbdae0d393b7d71480a6dace78456396b55286"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
        :revision => "9aae6aaa22315390f03959adca2c4d395b02fcef"
  end

  go_resource "github.com/goji/httpauth" do
    url "https://github.com/goji/httpauth.git",
        :revision => "c1b2bcd8769bd15cc56751223fd4b9f45ca987ca"
  end

  go_resource "github.com/gorilla/websocket" do
    url "https://github.com/gorilla/websocket.git",
        :revision => "361d4c0ffd78338ebe0a9e6320cdbe115d7dc026"
  end

  go_resource "github.com/juju/ratelimit" do
    url "https://github.com/juju/ratelimit.git",
        :revision => "772f5c38e468398c4511514f4f6aa9a4185bc0a0"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
        :revision => "d682a8f0cf139663a984ff12528da460ca963de9"
  end

  go_resource "github.com/rjeczalik/notify" do
    url "https://github.com/rjeczalik/notify.git",
        :revision => "1869adb163fffce8fb5b8755379d1042cdb4c4f8"
  end

  go_resource "github.com/toqueteos/webbrowser" do
    # v1.0
    url "https://github.com/toqueteos/webbrowser.git",
        :revision => "21fc9f95c83442fd164094666f7cb4f9fdd56cd6"
  end

  go_resource "github.com/alecthomas/template" do
    url "https://github.com/alecthomas/template.git",
        :revision => "b867cc6ab45cece8143cfcc6fc9c77cf3f2c23c0"
  end

  go_resource "github.com/alecthomas/units" do
    url "https://github.com/alecthomas/units.git",
        :revision => "2efee857e7cfd4f3d0138cc3cbb1b4966962b93a"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
        :revision => "51a7e7a8b1665b25ca173debdc8d52d493348f15"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
        :revision => "d6aaa2f596ae91a0a58d8e7f2c79670991468e4f"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "575fdbe86e5dd89229707ebec0575ce7d088a4a6"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "c764672d0ee39ffd83cfcb375804d3181302b62b"
  end

  go_resource "gopkg.in/alecthomas/kingpin.v2" do
    # v2.4.1
    url "https://github.com/alecthomas/kingpin.git",
        :revision => "95529ad11b3c862a5b828a2142b9e50db579cf2c"
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
