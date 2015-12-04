require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.5.0.tar.gz"
  sha256 "00aa2de781f70614b2ac82bbeb173784c77d3f507d47fa1d0a0246073e56bd62"

  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "9b624f888883b83a2a35bcfbe3508750263ca5b7ad9990c02b86461c9a5c62ca" => :el_capitan
    sha256 "392070a27d07cae3415bc88a844ae2dd3440d2a43e2b300eb869d6ecab1a7528" => :yosemite
    sha256 "0248f1f11ad819b2eeee27c269c27fede09f23ed7f46b1683453e5ef6589fc54" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p buildpath/"src/github.com/scaleway"
    ln_s buildpath, buildpath/"src/github.com/scaleway/scaleway-cli"
    Language::Go.stage_deps resources, buildpath/"src"

    inreplace "pkg/scwversion/placeholder.go" do |s|
      s.gsub! /VERSION = "master"/, "VERSION = \"v#{version}\""
      s.gsub! /GITCOMMIT = "master"/, "GITCOMMIT = \"v#{version}\""
    end
    system "go", "build", "-o", "scw", "./cmd/scw"
    bin.install "scw"

    bash_completion.install "contrib/completion/bash/scw"
    zsh_completion.install "contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
