class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.7/+download/juju-core_1.24.7.tar.gz"
  sha256 "ed9b4549602017794bce7a73317071318b6ee7d569f50bdf00bd9b2f8d2e991b"

  bottle do
    cellar :any_skip_relocation
    sha256 "86c024a0f80b3faddb2113c3e0ef830880380c6a91a8ddf5e675bf6999bad6aa" => :el_capitan
    sha256 "b9396deaff9adb5c9d56d67dcf4b3167d1516bb1ed31f5d98e39c99c410f0e89" => :yosemite
    sha256 "b4bec380a95b4802d13f7a9b6accd311ec6cbb39272ea60cb0b521f728d72b3e" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "go", "build", "github.com/juju/juju/cmd/juju"
    system "go", "build", "github.com/juju/juju/cmd/plugins/juju-metadata"
    bin.install "juju", "juju-metadata"
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
