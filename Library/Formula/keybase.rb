class Keybase < Formula
  desc "Command-line interface to Keybase.io"
  homepage "https://keybase.io/"
  url "https://github.com/keybase/client/archive/v1.0.6-0.tar.gz"
  sha256 "6942ac5ba511bf0411607e5c2292965bbc2fb2942f4bf2a1c8e79f25cd966676"
  version "1.0.6-0"

  head "https://github.com/keybase/client.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "8b62991167937765af9c53d834bb24dd7db348f726f1caa22224d28dda5d18a1" => :el_capitan
    sha256 "3aeb5d8a92372e1d217efc66a0f74c3b6135ded7f16e8627c289de0376d07d01" => :yosemite
    sha256 "62eacb5c2ef625e3c3d81be8fbe96b0555906d7d4663b3284b2b942c297010b8" => :mavericks
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
