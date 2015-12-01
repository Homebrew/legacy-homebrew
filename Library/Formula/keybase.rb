class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.4-0.tar.gz"
  sha256 "dee7df29dea556dc56ce20d8bc19810b721c579d64dab1c76f2f2049afc79a55"
  version "1.0.4-0"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3be6a9a301d57cfcc6f2a3f2c9a30af7e840d5ccf523413f6f1be9ea7a1382d7" => :el_capitan
    sha256 "954a0fd7a11e162baae8ebe9b470d7e0aa5d6d74ee36a08346bfa25fd74cfa95" => :yosemite
    sha256 "d112fd86d69840f4def2b0bdbbcd194d1ba740a98fe36e89206363d4c004f877" => :mavericks
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
