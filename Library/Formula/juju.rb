require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.1/+download/juju-core_1.20.1.tar.gz'
  sha1 'bdf806e0b3390fdb1a2503a663aeaa8b58ead696'

  bottle do
    sha1 "ba09b71468fd53965e2411d1f99c22061b33bc8a" => :mavericks
    sha1 "900751666032c38f70c58c24da4039333d6a8777" => :mountain_lion
    sha1 "a95d5de19f5d8676e67fc60c60b296d31049d3c0" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    args = %w(install github.com/juju/juju/cmd/juju)
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    bin.install 'bin/juju'
    bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
