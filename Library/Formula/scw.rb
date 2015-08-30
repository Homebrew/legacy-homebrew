require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.4.0.tar.gz"
  sha256 "ab7ee002be9557eb2b8075e3b0df340f5e379545152049f2512f1dc2b47b7b8a"

  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any
    sha256 "6685d169c38c3e629edec78b900a53e24a3d0096ff90d38c7d57ac42026de4ef" => :yosemite
    sha256 "2c3c748e2c755820bb710caa7461b53483d4f17314e17997fb33e239e3d20014" => :mavericks
    sha256 "3be8334bace6d1bb8a7ddc69e30f87bbff362264b81a40f3f8f487310c1f9186" => :mountain_lion
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
