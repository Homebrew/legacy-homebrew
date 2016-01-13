class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.8-0.tar.gz"
  sha256 "b43fc29e9ec6d06fb7371a597ad7a2f28ee8e125ae8b9c9c34d1c4d176b6a76d"
  version "1.0.8-0"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "1150c09a9833b6e5b6a8926ff5d1d645636364dc3633a3a0c30b309a5f46d7d1" => :el_capitan
    sha256 "b12987e6404c4fb6808ecb3e136490a428e5819ba632798cfb66645ba654df4a" => :yosemite
    sha256 "265f041ea4e57c46e20fdd1aff6ed3b91e01a10d729804cde9b5558da81fbf33" => :mavericks
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
