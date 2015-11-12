class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"

  url "https://github.com/keybase/client/archive/v1.0.0-46.tar.gz"
  sha256 "383625f3b3d4c2c78e68defc1d90c5e611441f5da03f3eebc0c4c1ffc6d305cd"
  head "https://github.com/keybase/node-client.git"

  head "https://github.com/keybase/client.git"
  version "1.0.0-46"

  depends_on "go" => :build

  bottle :unneeded

  def install
    ENV["GOPATH"] = buildpath
    ENV["GOBIN"] = buildpath
    ENV["GO15VENDOREXPERIMENT"] = "1"
    mkdir_p "src/github.com/keybase/client/"
    mv "go", "src/github.com/keybase/client/"

    system "go", "build", "-a", "-tags", "production brew", "github.com/keybase/client/go/keybase"

    bin.install "keybase"
  end

  def post_install
    system "#{opt_bin}/keybase", "launchd", "install", "homebrew.mxcl.keybase", "#{opt_bin}/keybase", "service"
  end

  test do
    system "#{bin}/keybase", "version"
  end
end
