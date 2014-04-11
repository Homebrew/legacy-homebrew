require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.1/+download/juju-core_1.18.1.tar.gz'
  sha1 '9109ad3fde28cca4e8056b5c3ebb0ef0a26b7275'

  bottle do
    sha1 "419261bda859fb6981daa950510dceb81869b504" => :mavericks
    sha1 "eac1b7e49f20a81876f9df7037bc3cc3ec360799" => :mountain_lion
    sha1 "b05f9f3d176e696dc4b40a370a247938f903ce95" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    args = %w(install launchpad.net/juju-core/cmd/juju)
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    bin.install 'bin/juju'
    bash_completion.install "src/launchpad.net/juju-core/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
