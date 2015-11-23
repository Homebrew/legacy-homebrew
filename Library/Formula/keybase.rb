class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.1-0.tar.gz"
  sha256 "accb7a232ab3788034c3bd992e65a3152f3e675f1333462c93020c537efa0a6c"
  version "1.0.1-0"

  head "https://github.com/keybase/client.git"

  bottle do
    sha256 "e680297fa09b43a2f6b1f361149096f31a2d5f57dfec41bec8d26fa5df575c88" => :el_capitan
    sha256 "16085f981d6b6cfb34ee6198fc525433107fd171970e8895096088b9a9aa5e97" => :yosemite
    sha256 "b6b97451768dd3e96ead3e14112c368ea76c2b96a3811cdf3237a48f889ef240" => :mavericks
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
