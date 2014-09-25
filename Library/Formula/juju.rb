require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.8/+download/juju-core_1.20.8.tar.gz'
  sha1 '9ca2d865e3051f05888c5aefff1d3f269294359e'

  bottle do
    sha1 "e31e839d1199ac922616c235fd92ed6391c4ad9b" => :mavericks
    sha1 "bbc47aadab320dcdee1d75b3c7ea0c375b4dbe0a" => :mountain_lion
    sha1 "fbe9d1e3630a5bb707bf689ca78439850adb79e8" => :lion
  end

  depends_on 'go' => :build

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
