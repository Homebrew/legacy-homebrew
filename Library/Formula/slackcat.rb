require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v0.9.tar.gz"
  sha256 "f537373080e184209e7e44288d0b10bcd827dc96b03acb0f3ec6fb94bb6fd851"

  bottle do
    cellar :any_skip_relocation
    sha256 "190dd307f186f4b8a457eadc575e795a88fdb01781e75b8cf4dae9a261825ead" => :el_capitan
    sha256 "ab5390db98946544443512529ccb2c65534a1ae7ffbbb9ff35720e05815a45e4" => :yosemite
    sha256 "9ff91d19442e47bd8f46223a87cf9cf173dff9158fc57b83fa82717c474b03cf" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
      :revision => "6d00f93158acefc3a0f605c171d1baa80ba86b73"
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
