require "language/go"

class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.0.0.tar.gz"
  sha256 "3b9df4e2409e37c8f74ab16e4d276544bac81acd66caabdab62b07f321adc0a1"
  head "https://github.com/Tonkpils/snag.git"

  bottle do
    cellar :any
    sha256 "28b858b8b2cba0a79444018fbf382c002ecd905a35d75353a6db0626e436aa41" => :yosemite
    sha256 "9fea39e73b26377b0904e88f954f2ebbb575fcd668ea32723f50aae1770ec9cd" => :mavericks
    sha256 "a279c7f9e5f754480acdec327628b0b0593ba5390aac2408498b1930fc72434f" => :mountain_lion
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
