require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.1/+download/juju-core_1.18.1.tar.gz'
  sha1 '9109ad3fde28cca4e8056b5c3ebb0ef0a26b7275'

  devel do
    url "https://launchpad.net/juju-core/trunk/1.19.1/+download/juju-core_1.19.1.tar.gz"
    sha1 "0bf1f8fcf5788907b960c1581007f9fd45126d21"
  end

  bottle do
    sha1 "5e2c7004214bd1bb09f356f4bc18c86dd729cdee" => :mavericks
    sha1 "4725f55dd9345ece43202538c56d7afcd29f3a3e" => :mountain_lion
    sha1 "62f01417603e907838d423d39bb8fc01ed5b564b" => :lion
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
