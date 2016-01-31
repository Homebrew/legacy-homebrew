require "language/go"

class Mpdviz < Formula
  desc "Standalone console MPD visualizer"
  homepage "https://github.com/lucy/mpdviz"
  url "https://github.com/lucy/mpdviz/archive/0.4.6.tar.gz"
  sha256 "c34243ec3f3d91adbc36d608d5ba7082ff78870f2fd76a6650d5fb3218cc2ba3"

  depends_on "pkg-config" => :build
  depends_on "go" => :build
  depends_on "fftw"

  go_resource "github.com/lucy/go-fftw" do
    url "https://github.com/lucy/go-fftw.git",
      :revision => "37bfa0d3053b133f7067e9524611a7a963294124"
  end

  go_resource "github.com/lucy/pflag" do
    url "https://github.com/lucy/pflag.git",
      :revision => "20db95b725d76759ba16e25ae6ae2ec67bf45216"
  end

  go_resource "github.com/lucy/termbox-go" do
    url "https://github.com/lucy/termbox-go.git",
      :revision => "a09edf97f26bd0a461d4660b5322236ecf9d4397"
  end

  go_resource "github.com/mattn/go-runewidth" do
    url "https://github.com/mattn/go-runewidth.git",
      :revision => "36f63b8223e701c16f36010094fb6e84ffbaf8e0"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "mpdviz"
    bin.install "mpdviz"
  end
end
