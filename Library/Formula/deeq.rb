require "formula"
require "language/go"

class Deeq < Formula
  homepage "http://deeqapp.com"
  url "https://github.com/bithavoc/deeq-cli/archive/v1.0.1.tar.gz"
  sha1 "eb0e3a58e567b78f219c876e3c9f9b50a1063757"

  head "https://github.com/bithavoc/deeq-cli.git"
  depends_on "go" => :build

  go_resource "github.com/bithavoc/goprompt" do
    url "https://github.com/bithavoc/goprompt.git",
      :tag => "v0.1.0"
  end

  go_resource "github.com/bithavoc/id-go-client" do
    url "https://github.com/bithavoc/id-go-client.git",
      :tag => "v0.1.0"
  end

  go_resource "github.com/bithavoc/deeq-go-client" do
    url "https://github.com/bithavoc/deeq-go-client.git",
      :tag => "v0.1.0"
  end

  def install
    ENV["GOPATH"] = buildpath
    Language::Go.stage_deps resources, buildpath/"src"
    system "go", "build", "-o", "deeq", "."
    bin.install "deeq"
  end

  test do
    system "#{bin}/deeq", "version"
  end

end
