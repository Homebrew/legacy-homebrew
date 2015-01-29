require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.21/1.21.1/+download/juju-core_1.21.1.tar.gz'
  sha1 '760281b70c33b6f7fd2c24525d9a892a3deec5df'

  bottle do
    sha1 "ac3d5c6a9db95e1019cef093588441ad23c30d63" => :yosemite
    sha1 "3c0442d2bbf00b8a46b6a284702a0057a924cb98" => :mavericks
    sha1 "2aee0c6523269e5bfbc588c927be7a5fb4f98a44" => :mountain_lion
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
