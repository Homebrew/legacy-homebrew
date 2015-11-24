class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.2-0.tar.gz"
  sha256 "14affad70f53e96c3f1dd1cec00c90bb7861c161430ba114c76e58bb71b6fc42"
  version "1.0.2-0"

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
