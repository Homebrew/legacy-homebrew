require "language/go"

class Slackcat < Formula
  desc "Command-line utility for posting snippets to Slack"
  homepage "https://github.com/vektorlab/slackcat"
  url "https://github.com/vektorlab/slackcat/archive/v0.7.tar.gz"
  sha256 "b51ab794af2a0014b5372944699d7ff9c88af4e1860206abee3a0f9bbc70d147"

  depends_on "go" => :build

  go_resource "github.com/bluele/slack" do
    url "https://github.com/bluele/slack.git",
      :revision => "97c70c3d5d5d7a30e336180e1a8b4b768a9b6857"
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

    system "go", "build", "-ldflags", "-s -X main.version=#{version}", "-o", bin/"slackcat", "slackcat.go"
  end

  test do
    assert_match /slackcat version #{version}/, shell_output("#{bin}/slackcat -v")
  end
end
