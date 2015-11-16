require "language/go"

class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.1.0.tar.gz"
  sha256 "30197526352284067ebc7f8c066da37e1e92f535dcf7a185584bdc4d8ef37233"
  head "https://github.com/Tonkpils/snag.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "0440b77998204934baafcd3d607c1fee407a3116b4b0b23dd3b91dd0a29ebe04" => :el_capitan
    sha256 "b2c058bcdab37bc890e03b843fcb07f500d0ccce5157c94cb75ab0bc0f629f71" => :yosemite
    sha256 "a65fc487274d29dc68d8dba8cc85318606dae4c55aa64446fc61e76c5d82ed60" => :mavericks
  end

  depends_on "go" => :build

  go_resource "gopkg.in/yaml.v2" do
    url "https://github.com/go-yaml/yaml.git",
      :revision => "7ad95dd0798a40da1ccdff6dff35fd177b5edf40"
  end

  go_resource "github.com/shiena/ansicolor" do
    url "https://github.com/shiena/ansicolor.git",
      :revision => "a5e2b567a4dd6cc74545b8a4f27c9d63b9e7735b"
  end

  go_resource "github.com/mattn/go-isatty" do
    url "https://github.com/mattn/go-isatty.git",
      :revision => "7fcbc72f853b92b5720db4a6b8482be612daef24"
  end

  go_resource "gopkg.in/fsnotify.v1" do
    url "https://github.com/go-fsnotify/fsnotify.git",
      :revision => "96c060f6a6b7e0d6f75fddd10efeaca3e5d1bcb0"
  end

  go_resource "github.com/fatih/color" do
    url "https://github.com/fatih/color.git",
      :revision => "2f376994f3b3cae1602f63eb5bdfb58101a94a08"
  end

  def install
    ENV["GOPATH"] = buildpath

    snagpath = buildpath/"src/github.com/Tonkpils/snag"
    snagpath.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd snagpath do
      system "go", "build", "-o", bin/"snag"
    end
  end

  test do
    (testpath/".snag.yml").write <<-EOS.undent
      script:
        - touch #{testpath}/snagged
      verbose: true
    EOS
    begin
      pid = fork do
        exec bin/"snag"
      end
      sleep 0.5
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    File.exist? testpath/"snagged"
  end
end
