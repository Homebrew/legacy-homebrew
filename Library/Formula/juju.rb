require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.2/+download/juju-core_1.18.2.tar.gz'
  sha1 '80b3be18dc45f76ac3c5270dfb9e1da1f8e2071b'

  devel do
    url "https://launchpad.net/juju-core/trunk/1.19.1/+download/juju-core_1.19.1.tar.gz"
    sha1 "0bf1f8fcf5788907b960c1581007f9fd45126d21"
  end

  bottle do
    sha1 "4a61fabc0412aa5df2f7398ff3128f410321f8a4" => :mavericks
    sha1 "59fb2af4289dbd34b04c8ef4e135ba862803025a" => :mountain_lion
    sha1 "0033afd48c60c044e74e9ed4a19063d08975d7a8" => :lion
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
