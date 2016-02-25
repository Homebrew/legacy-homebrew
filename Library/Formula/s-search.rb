require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.4.2.tar.gz"
  sha256 "12f1e9ff5d52703d8e8e14755c8b34d3c15d9f39295222c16860077c15cef807"

  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "412292df3b6c57ba3111f0671a4040334cfb022c5f84203142f29786e3bedb34" => :el_capitan
    sha256 "009ad64b5fc9fea55ebf98139c2b3c8af8fb6175f03a9024d716a010a0a83cad" => :yosemite
    sha256 "5f10f0ddbb727c7f9c2f981e4337fabe255f00274ba9b6455a082df7cc73e765" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/mitchellh/go-homedir" do
    url "https://github.com/mitchellh/go-homedir.git",
      :revision => "d682a8f0cf139663a984ff12528da460ca963de9"
  end

  go_resource "github.com/spf13/cobra" do
    url "https://github.com/spf13/cobra.git",
      :revision => "65a708cee0a4424f4e353d031ce440643e312f92"
  end

  go_resource "github.com/zquestz/go-ucl" do
    url "https://github.com/zquestz/go-ucl.git",
      :revision => "9e5940bb3930921a83dcb0f9e20a32e3b1335590"
  end

  go_resource "github.com/NYTimes/gziphandler" do
    url "https://github.com/NYTimes/gziphandler.git",
      :revision => "a88790d49798560db24af70fb6a10a66e2549a72"
  end

  go_resource "github.com/spf13/pflag" do
    url "https://github.com/spf13/pflag.git",
      :revision => "7f60f83a2c81bc3c3c0d5297f61ddfa68da9d3b7"
  end

  go_resource "golang.org/x/text" do
    url "https://go.googlesource.com/text.git",
      :revision => "07b9a78963006a15c538ec5175243979025fa7a8"
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
