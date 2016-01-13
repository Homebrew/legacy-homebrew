class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.8-0.tar.gz"
  sha256 "b43fc29e9ec6d06fb7371a597ad7a2f28ee8e125ae8b9c9c34d1c4d176b6a76d"
  version "1.0.8-0"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "49c7dbe99b0ecdedf82e5d2552c078a4e49fc4a163384f2a262c2d8d1e349605" => :el_capitan
    sha256 "45847a5c4f034347c3ad9be46c1cc27cbef2592a83bdcfbf394781a90ff275c3" => :yosemite
    sha256 "df3136c47a782b55b8b7bd9dde29d73a2dfda2aa1aff099b2daf438d8f3abbac" => :mavericks
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
