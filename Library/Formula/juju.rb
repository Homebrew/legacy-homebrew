class Juju < Formula
  desc "DevOps management tool"
  homepage "https://juju.ubuntu.com"
  url "https://launchpad.net/juju-core/1.25/1.25.0/+download/juju-core_1.25.0.tar.gz"
  sha256 "48fb99f5eef4e5313ae5c19d03aefd5632225e52d0814792ceab7b758d6713e0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4652fae4797f2d1f92a90d7a786c15cfc840d2a9263a86b08272f31152179693" => :el_capitan
    sha256 "093c006a5794c59cddf0519b5441ed85d98fd87b4db1facd4faae3fe782966b3" => :yosemite
    sha256 "d38cf62e005beff128c38ea47ffa9b42d845b9c0353283a0311c4a02ed38dd46" => :mavericks
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
