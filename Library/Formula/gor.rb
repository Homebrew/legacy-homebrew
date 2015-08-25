require "language/go"

class Gor < Formula
  desc "Simple http traffic replication tool written in Go"
  homepage "https://github.com/buger/gor/"

  # buildscript requires the .git directory be present
  url "https://github.com/buger/gor.git",
    :tag => "v0.8.4", :revision => "a6af811c5067c9394451da3781310eb468091f3d"

  depends_on "go" => :build

  go_resource "github.com/mattbaird/elastigo" do
    url "https://github.com/mattbaird/elastigo.git"
  end

  def install
    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", buildpath

    gor_path = buildpath/"src/github.com/buger/gor"
    gor_path.install Dir["{*,.git}"]
    Language::Go.stage_deps resources, buildpath/"src"

    cd "src/github.com/buger/gor" do
      system "go", "build"
      buildpath.install "gor"
    end
  end
end
