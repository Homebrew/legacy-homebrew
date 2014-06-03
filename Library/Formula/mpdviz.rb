require "formula"
require "language/go"

class Mpdviz < Formula
  homepage "https://github.com/neeee/mpdviz"
  url "http://github.com/neeee/mpdviz/archive/0.4.3.tar.gz"
  sha1 "7923a818155c9fc413e483dcb1b3964ab00e5ded"

  go_resource "github.com/neeee/go-fftw" do
    url "https://github.com/neeee/go-fftw.git",
      :revision => "37bfa0d3053b133f7067e9524611a7a963294124"
  end

  go_resource "github.com/neeee/pflag" do
    url "https://github.com/neeee/pflag.git",
      :revision => "3eff50031ed8a4d175401fe12d1c8a24415cbe9f"
  end

  go_resource "github.com/neeee/termbox-go" do
    url "https://github.com/neeee/termbox-go.git",
      :revision => "7d25635285663eedf1aaa26dda7e5b3213045772"
  end

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "fftw"

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "mpdviz"
    bin.install "mpdviz"
  end
end
