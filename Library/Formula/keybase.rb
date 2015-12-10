class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.6-0.tar.gz"
  sha256 "6942ac5ba511bf0411607e5c2292965bbc2fb2942f4bf2a1c8e79f25cd966676"
  version "1.0.6-0"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "31e8f3d4ca83788e3dfeccd02fdeee982cd8485bc847abe7d9491fd0a8a6a43f" => :el_capitan
    sha256 "63643847e90292aedde2f6cc857df38198d6705cedd987f7e603f1bdda295ca6" => :yosemite
    sha256 "a3770d03fcd1deb48e97e4bab7f057f850cf903eb611250481eb22a1b182a798" => :mavericks
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
