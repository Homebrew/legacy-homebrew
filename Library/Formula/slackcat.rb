require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v0.8.tar.gz"
  sha256 "90a9b8255dbc8a2cb97061688b3034627e59111904c07c04552c6f0e6021badc"

  bottle do
    cellar :any_skip_relocation
    sha256 "d060276dad87e703b9c43cd31e6cfcdf1ab105ba0f41a8d81bd18e5306777dab" => :el_capitan
    sha256 "af05bb5d4a831de18d09ba88b342c4a9aca051a1c3fe6836103fca4b6e923537" => :yosemite
    sha256 "7d5ffabf0caaef172e90a7ed001e5440d23ee445f5d9020e0afaf6b31756b914" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
      :revision => "fe9384fb313d98f2b9c5bba293074416c52fcc6c"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "c31a7975863e7810c92e2e288a9ab074f9a88f29"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
      :revision => "9aae6aaa22315390f03959adca2c4d395b02fcef"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
      :revision => "56b76bdf51f7708750eac80fa38b952bb9f32639"
  end

  go_resource "github.com/mattn/go-colorable" do
    url "https://github.com/mattn/go-colorable.git",
      :revision => "3dac7b4f76f6e17fb39b768b89e3783d16e237fe"
  end

  go_resource "github.com/skratchdot/open-golang" do
    url "https://github.com/skratchdot/open-golang.git",
      :revision => "c8748311a7528d0ba7330d302adbc5a677ef9c9e"
  end

  def install
    ENV["GOBIN"] = bin
    ENV["GOPATH"] = buildpath
    ENV["GOHOME"] = buildpath

    mkdir_p buildpath/"src/github.com/vektorlab/"
    ln_sf buildpath, buildpath/"src/github.com/vektorlab/slackcat"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-s -X main.version=#{version}", "-o", bin/"slackcat"
  end

  test do
    assert_match /slackcat version #{version}/, shell_output("#{bin}/slackcat -v")
  end
end
