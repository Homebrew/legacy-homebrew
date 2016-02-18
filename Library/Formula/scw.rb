require "language/go"

class Scw < Formula
  desc "Manage BareMetal Servers from Command Line (as easily as with Docker)"
  homepage "https://github.com/scaleway/scaleway-cli"
  url "https://github.com/scaleway/scaleway-cli/archive/v1.7.1.tar.gz"
  sha256 "d63701546806cce3cf68f180b32ae5e0f52e9cf239cf8c2565b29c30c7b300f1"

  head "https://github.com/scaleway/scaleway-cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b51acc7141f5d567ad41da84ba95358d55287a37ff6a06c50628868b87b5bf32" => :el_capitan
    sha256 "76961fc3752f5643776681ebe3207a2ec537ec5e4586675da6f8b02d7b5b6899" => :yosemite
    sha256 "8e3f270478dd333bbd2b9a8ff4a4a4b281b691d89e85a56ca6df5d5435997dd0" => :mavericks
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
