class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.13-0.tar.gz"
  version "1.0.13-0"
  sha256 "27a619fdccbc9cc91a7e0f4048e1f728093826cd8097a58e466adfa7ef54b5ad"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8f3fd71983fb22b6e1e1c5fc89150ab5e2702f1348c25cef60b5e2e8c02cf8e6" => :el_capitan
    sha256 "03cd7695ff8a2f31eaf8ce2d6083b645ca0f235edb29dea80a38169e128666c5" => :yosemite
    sha256 "6257e1ccb1b87708e0fbd78b7fbebc5e9b77804e46e889cd18f9b64c6efed926" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    (buildpath/"src/github.com/keybase/client/").install "go"

    system "go", "build", "-a", "-tags", "production brew", "github.com/keybase/client/go/keybase"
    bin.install "keybase"
  end

  test do
    system "#{bin}/keybase", "-standalone", "id", "homebrew"
  end
end
