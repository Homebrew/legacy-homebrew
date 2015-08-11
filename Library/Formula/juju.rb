class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.24/1.24.5/+download/juju-core_1.24.5.tar.gz"
  sha256 "3ffecd4613961f588d67f7f44877080b409f77379d59d239c64d88afe94c187f"

  bottle do
    cellar :any
    sha256 "d3366546c922511aa3efd49fa3d007949ff796f8cb6e3e21730b48ad27688406" => :yosemite
    sha256 "887b16a687a50d693501481f2115fbc0e72d363c8d429cf9deb67cedde7df813" => :mavericks
    sha256 "4c040edf953d51ce5493d825b652bc03d3adb27ae79e9f0ec5cea3f781105492" => :mountain_lion
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
