class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.3-0.tar.gz"
  sha256 "e384c1dfadb1f1def2cc7f66134fff4992ee3c5083acceacd3f1efd1ea17d8b3"
  version "1.0.3-0"

  head "https://github.com/keybase/client.git"

  bottle do
    sha256 "3048d0edd46a84fbeb74ac4972cc7ab67c821496545232026529fa15a36d607b" => :el_capitan
    sha256 "81d832ee8170fae1971813ffd2e1604d6a596c4771bd76a79e9c6effbe14b5cb" => :yosemite
    sha256 "a3c1aa2263b05808ca0875391310316beacde285dade434bcc93303dfa823dd6" => :mavericks
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
