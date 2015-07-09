require "formula"
require "language/go"

class Glide < Formula
  desc "Simplified Go project management, dependency management, and vendoring"
  homepage "https://github.com/Masterminds/glide"
  url "https://github.com/Masterminds/glide/archive/0.4.0.tar.gz"
  sha256 "59864298cb458b443af3bbaeab9ad8371dbcfd0152cdd444f666062833b83292"

  bottle do
    cellar :any
    sha256 "5371ffac49c2a2214aed86a2d221662ff0a25ccc42d2d6054f4307fd11ae80d0" => :yosemite
    sha256 "17119f94d330b63b2909aa1c944c835babcb5c9af1fc9e065c0236d2d55e9c58" => :mavericks
    sha256 "009e82b7425cba2c365533600621934ce9209e827f763cb2d51ad9cebc662e89" => :mountain_lion
  end

  depends_on "go" => :build

  go_resource "github.com/kylelemons/go-gypsy" do
    url "https://github.com/kylelemons/go-gypsy.git",
      :revision => "42fc2c7ee9b8bd0ff636cd2d7a8c0a49491044c5"
  end

  go_resource "github.com/Masterminds/cookoo" do
    url "https://github.com/Masterminds/cookoo.git",
      :revision => "623f8762b2474f1ad6c2cac6bf331b8871591379"
  end

  go_resource "github.com/codegangsta/cli" do
    url "https://github.com/codegangsta/cli.git",
      :revision => "ad480243a8a6cda30acf7cd999ea3e5142154fde"
  end

  def install
    (buildpath + "src/github.com/Masterminds/glide").install "glide.go", "cmd"

    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "glide", "-ldflags", "-X main.version 0.4.0", "#{buildpath}/src/github.com/Masterminds/glide/glide.go"
    bin.install "glide"
  end

  test do
    version = pipe_output("#{bin}/glide --version")
    assert_match /0.4.0/, version
  end
end
