class Fleetctl < Formula
  desc "Distributed init system"
  homepage "https://github.com/coreos/fleet"
  url "https://github.com/coreos/fleet/archive/v0.11.5.tar.gz"
  sha256 "a6a785099df71645b5fe8755a36baa6c11138749bc02ae4990fd3f52663c0394"
  revision 1

  head "https://github.com/coreos/fleet.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5cbe19ef4a338f385fa2f5ab8367155f28488f5bff8778e7e5a6d99a0811d78d" => :el_capitan
    sha256 "e9d42b3c4201e3e205ee5831a6260c5b3e43ecb402c4926e0f461874c8c04721" => :yosemite
    sha256 "cdc085a93ce8437ce3b4bdbdff3a8b41fa7f6bc67fb066a6c41bee12a0a5f17e" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    system "./build"
    bin.install "bin/fleetctl"
  end

  test do
    system "#{bin}/fleetctl", "-version"
  end
end
