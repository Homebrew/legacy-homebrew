class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.11-0.tar.gz"
  version "1.0.11-0"
  sha256 "3f89b83b43294822a3ed6fe8d364a755fc45439f7da7c7f2e33541f9545b6e15"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f08162502eaa28b35156dd6fd4ae3703e92bdcbc741cc84d5edcae753ba7e93a" => :el_capitan
    sha256 "99e9afa94440ff7b4b64daf2c960cbb75e63d3d9b1298bce5221c2cff3b36c17" => :yosemite
    sha256 "29aeef8b25b37e58fddf98259f6451801bf2d00a62ef42bfe40ebd0e839f5f21" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    (buildpath/"src/github.com/keybase/client/").install "go"

    system "go", "build", "-a", "-tags", "production brew", "github.com/keybase/client/go/keybase"
    bin.install "keybase"
  end

  test do
    system "#{bin}/keybase", "-standalone", "id", "homebrew"
  end
end
