class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.5/+download/juju-core_1.24.5.tar.gz"
  sha256 "3ffecd4613961f588d67f7f44877080b409f77379d59d239c64d88afe94c187f"

  bottle do
    cellar :any
    sha256 "0edfb2f7cbf65f9e71e96831280ef2c748a0c2aa1424b9131c0f9ca9b3b54c89" => :yosemite
    sha256 "1c93c724ad0f68a11fc45db936a8130a56a9646a9c2f979accbb6641356fc762" => :mavericks
    sha256 "ff279800b3e7f5014e66cbe63ab00ac5fe7ae8b81c177e8fc58c54bb9db674c1" => :mountain_lion
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
