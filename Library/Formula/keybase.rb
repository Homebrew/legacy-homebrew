class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.3-0.tar.gz"
  sha256 "e384c1dfadb1f1def2cc7f66134fff4992ee3c5083acceacd3f1efd1ea17d8b3"
  version "1.0.3-0"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "6f2d82b91ed6563dc05256e60b44089b0ef61a5f816f89bdbdf873f38e4c940c" => :el_capitan
    sha256 "4a7c70618b842b547c05505df2d92d6afab1d24e133ff9ad1780f164a457fbae" => :yosemite
    sha256 "a6ae81c05c0cf58d32bdec74bcd10dcd8c47a2ed43f1c473fce025dcb7205005" => :mavericks
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
