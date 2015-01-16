require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.14/+download/juju-core_1.20.14.tar.gz'
  sha1 'aca9765276c3c60c0c4d6c4b7a8d72d0ab3c5fcd'

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
