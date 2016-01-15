class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.8-0.tar.gz"
  version "1.0.8-0"
  sha256 "b43fc29e9ec6d06fb7371a597ad7a2f28ee8e125ae8b9c9c34d1c4d176b6a76d"
  revision 1

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "269b8bc09a110546a1b5e2370500c221f67ed886cdfdd673abbdb0145578d5c9" => :el_capitan
    sha256 "ae4d5b75181f9d5008acd0af3105a2663d65acee496d51e7924aa4fb386f2673" => :yosemite
    sha256 "df7b7b7e67ce13d40d38c2019bc47f0baadb0ce492f57232c472d39de530bbc1" => :mavericks
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
