require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.4.5.tar.gz"
  sha256 "5c6cc19f3e66b5a98eb757e7b42d6faaceeff3c88a3d4c57af2107ac3be20a19"

  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "dc7219a4610ae994e217543289935fd3d00b2f0038e9ef318aed1e1e9c443952" => :el_capitan
    sha256 "28c0eddd56ddfe99c3c30e4fea6c1a288f595b84158aa6f85f4f8a65b3f05e14" => :yosemite
    sha256 "46cc653b0036738fa31b89498af1673052f24a255b5363ed611183da5c2fbb59" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/NYTimes/gziphandler" do
    url "https://github.com/NYTimes/gziphandler.git",
    :revision => "a88790d49798560db24af70fb6a10a66e2549a72"
  end

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
    :revision => "981ab348d865cf048eb7d17e78ac7192632d8415"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
    :revision => "966e6048eb43ccf9f240a078557b37f0a407f1df"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
    :revision => "7f60f83a2c81bc3c3c0d5297f61ddfa68da9d3b7"
  end

  go_resource "github.com/zquestz/go-ucl" do
    url "https://github.com/zquestz/go-ucl.git",
    :revision => "ec59c7af0062f62671cdc1e974aa857771f105d2"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
    :revision => "1b466db55e0ba5d56ef5315c728216b42f796491"
  end

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/zquestz").mkpath
    ln_s buildpath, buildpath/"src/github.com/zquestz/s"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "#{bin}/s"
  end

  test do
    assert_equal "https://www.google.com/search?q=homebrew\n",
      shell_output("#{bin}/s -p google -b echo homebrew")
  end
end
