class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.9-0.tar.gz"
  version "1.0.9-0"
  sha256 "01999048454877bc3b6a2934a8c1bfda4ebef31400698627a23b94450d5b2409"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "772674d37beb75b8f37ad764a5c11c90b2ea22a9390e93f5451724ebad015451" => :el_capitan
    sha256 "b2119bd160ed5aa05d404cf6bc821f75540e52fdacfa5eb7125ba8c6525b8ca0" => :yosemite
    sha256 "190289ba1a9c1c8e9ce8711ab08dccaa2b92494e7ab8dc29f6936528a97b14a2" => :mavericks
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
