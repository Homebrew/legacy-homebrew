require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.3.0.tar.gz"
  sha256 "b02ed007f831b9ffd79be0b670c6c1bfa59a87ba87ac54dea48005cfb305f5c7"

  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any
    sha256 "984ff8887abe0b892f7c9e19aaf10ca28116935e43a9c8cb14b791666610a7d2" => :yosemite
    sha256 "bb5eaebc4b96bae9fdfe8a5b63998e877fc1b70d382d7fe6da6fda5eee745709" => :mavericks
    sha256 "e6ef89e699e38a0fc1db5719f2df0f2831be64fe2f9c3d47e71c44e0e8899aab" => :mountain_lion
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["CGO_ENABLED"] = "0"
    ENV.prepend_create_path "PATH", buildpath/"bin"

    mkdir_p buildpath/"src/github.com/scaleway"
    ln_s buildpath, buildpath/"src/github.com/scaleway/scaleway-cli"
    Language::Go.stage_deps resources, buildpath/"src"

    system "go", "build", "-o", "scw", "."
    bin.install "scw"

    bash_completion.install "contrib/completion/bash/scw"
    zsh_completion.install "contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
