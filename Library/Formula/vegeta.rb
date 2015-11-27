require "language/go"

class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta/archive/v6.0.0.tar.gz"
  sha256 "7933a77eaae1e5269f6490842527a646221d91515eb8e863e831df608e7a0d48"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ff4145c46b62cb1b237e73b47962a195bcf539074d7de28ed0fa9e9af116288" => :el_capitan
    sha256 "6c4bc20809f0891036aafe2afb2ea7fff2bb3914bc07707c22b6cff16563bc2e" => :yosemite
    sha256 "d7778670b369b8fa10221ec89f615657cf2d2d5e92db78956ebfb26530d54707" => :mavericks
  end

  depends_on "go" => :build

  go_resource "github.com/streadway/quantile" do
    url "https://github.com/streadway/quantile.git",
      :revision => "b0c588724d25ae13f5afb3d90efec0edc636432b"
  end

  def install
    mkdir_p buildpath/"src/github.com/tsenart/"
    ln_s buildpath, buildpath/"src/github.com/tsenart/vegeta"
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-ldflags", "-X main.Version=#{version}", "-o", "vegeta"
    bin.install "vegeta"
  end

  test do
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", "GET http://localhost/")
    pipe_output("#{bin}/vegeta report", output)
  end
end
