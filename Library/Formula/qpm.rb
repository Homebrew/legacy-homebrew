require "language/go"

class Qpm < Formula
  desc "Package manager for Qt applications"
  homepage "https://www.qpm.io"
  url "https://github.com/Cutehacks/qpm.git",
      :tag => "v0.10.0",
      :revision => "b0dfc0f26e009ff778cc25ebb8b166fa460ea998"

  depends_on "go" => :build

  go_resource "github.com/golang/protobuf" do
    url "https://github.com/golang/protobuf.git",
        :revision => "d3d78384b82d449651d2435ed329d70f7c48aa56"
  end

  go_resource "github.com/howeyc/gopass" do
    url "https://github.com/howeyc/gopass.git",
        :revision => "10b54de414cc9693221d5ff2ae14fd2fbf1b0ac1"
  end

  go_resource "golang.org/x/crypto" do
    url "https://go.googlesource.com/crypto.git",
        :revision => "575fdbe86e5dd89229707ebec0575ce7d088a4a6"
  end

  go_resource "golang.org/x/net" do
    url "https://go.googlesource.com/net.git",
        :revision => "042ba42fa6633b34205efc66ba5719cd3afd8d38"
  end

  go_resource "google.golang.org/grpc" do
    url "https://github.com/grpc/grpc-go.git",
        :revision => "3490323066222fe765ef7903b53a48cbc876906d"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "bin/qpm", "qpm.io/qpm"
    bin.install "bin/qpm"
  end

  test do
    system bin/"qpm", "install", "io.qpm.example"
    assert File.exist?(testpath/"qpm.json")
  end
end
