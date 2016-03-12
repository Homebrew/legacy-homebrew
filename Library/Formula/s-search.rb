require "language/go"

class SSearch < Formula
  desc "Web search from the terminal"
  homepage "https://github.com/zquestz/s"
  url "https://github.com/zquestz/s/archive/v0.4.5.tar.gz"
  sha256 "5c6cc19f3e66b5a98eb757e7b42d6faaceeff3c88a3d4c57af2107ac3be20a19"

  head "https://github.com/zquestz/s.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "82eda6134cbaa8e27af5bd148b80d108d89ad07e4ab3679e67e6e6714b0a5308" => :el_capitan
    sha256 "170e8329552c2974aaf166758d0f150d69202b9bad1d55989b0fa177a4a21ddc" => :yosemite
    sha256 "e3527d897baba4bfba655d2b427c9c1e635437c4d03c7ff78acc3a0b94b2de3d" => :mavericks
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
