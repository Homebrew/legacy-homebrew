require "language/go"

class Gdrive < Formula
  desc "Google Drive CLI Client"
  homepage "https://github.com/prasmussen/gdrive"
  url "https://github.com/prasmussen/gdrive/archive/1.6.1.tar.gz"
  sha256 "50d5851c6f6cfa52713c001dae03a2c189ee3d9a255e8bf58ce8d4dadab5b9fc"

  head "https://github.com/prasmussen/gdrive.git"

  bottle do
    cellar :any
    sha256 "880f1d01fa1d75cf1b68c458535812dc44bbe9a698814ca0ac24c5b055560b38" => :yosemite
    sha256 "a5369d9bf8f0de58a5e226b664ec0f113a5651a239f2d575e13151b2a8823ce3" => :mavericks
    sha256 "244ee2e75c2dfa205c7c7248ef3f0624d5132f1fb1d06011a47aaddeb151bba0" => :mountain_lion
  end

  depends_on :hg => :build
  depends_on "go" => :build

  go_resource "code.google.com/p/goauth2" do
    url "https://code.google.com/p/goauth2/", :revision => "afe77d958c70", :using => :hg
  end

  go_resource "github.com/prasmussen/gdrive" do
    url "https://github.com/prasmussen/gdrive.git", :revision => "24950968ecea619378a36edff78e46fee0eb3a43"
  end

  go_resource "github.com/prasmussen/google-api-go-client" do
    url "https://github.com/prasmussen/google-api-go-client.git", :revision => "01eb774ccc14e64c3c950e85afd84a8b48b2ac1e"
  end

  go_resource "github.com/voxelbrain/goptions" do
    url "https://github.com/voxelbrain/goptions.git", :revision => "68583de33d9209ba795a0a334dad27418e4c18f5"
  end

  go_resource "google.golang.org/api" do
    url "https://github.com/prasmussen/google-api-go-client.git", :revision => "01eb774ccc14e64c3c950e85afd84a8b48b2ac1e"
  end

  go_resource "golang.org/x/net" do
    url "https://github.com/golang/net.git", :revision => "84ba27dd5b2d8135e9da1395277f2c9333a2ffda"
  end

  def install
    mkdir_p "#{buildpath}/src/github.com/prasmussen/"
    ln_s buildpath, "#{buildpath}/src/github.com/prasmussen/gdrive"

    ENV["GOPATH"] = buildpath
    ENV.append_path "PATH", "#{ENV["GOPATH"]}/bin"

    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "drive.go"
    bin.install "drive"
  end

  test do
    system "#{bin}/drive", "--help"
  end
end
