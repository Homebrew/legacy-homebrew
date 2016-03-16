class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.14-1.tar.gz"
  version "1.0.14-1"
  sha256 "ef8f6d01206428a99558885ecec8de99089a60fe5f4b6e6f425e01a3fb368853"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "7bb1a2c16840f219e24fe79e2b125a89324416bd8a9f3e42c75231a58c31fc00" => :el_capitan
    sha256 "91c6561cedf3bc485d27d82a55e9a66385cff3db17ce27d47b0f6e5b5d231d7a" => :yosemite
    sha256 "12198ddd5fd25e5c77f154428470ca21504f6495fd9f8c3e7f44df7d05fa73e5" => :mavericks
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
