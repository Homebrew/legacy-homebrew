require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.8.1.tar.gz"
  sha256 "9cb8626a8ab254aa602ded0a46ad0c34f88c9f89e7da28049b166996f494dde9"
  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "91110a8d1e5fb64366fe916c3a5fc82259561abfd44e0594e3358ceb18e00c88" => :el_capitan
    sha256 "c4649ecbf09b109544dec133e138ed364073b780d02c42db9aa1ed1fcbadb45c" => :yosemite
    sha256 "ddc3cbe66f2337bdce3f701a3afdf28aaa25fa6503d2a090645f5c7068d9a3c4" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/scaleway/scaleway-cli").install Dir["*"]

    system "go", "build", "-o", "#{bin}/scw", "-v", "-ldflags", "-X  github.com/scaleway/scaleway-cli/pkg/scwversion.GITCOMMIT=homebrew", "github.com/scaleway/scaleway-cli/cmd/scw/"

    bash_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/bash/scw"
    zsh_completion.install "src/github.com/scaleway/scaleway-cli/contrib/completion/zsh/_scw"
  end

  test do
    output = shell_output(bin/"scw version")
    assert_match "OS/Arch (client): darwin/amd64", output
  end
end
