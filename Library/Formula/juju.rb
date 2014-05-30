require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.3/+download/juju-core_1.18.3.tar.gz'
  sha1 '9290acb390d7bcefd56212de1a8a36c008f5db89'

  devel do
    url 'https://launchpad.net/juju-core/trunk/1.19.3/+download/juju-core_1.19.3.tar.gz'
    sha1 '9ef0ce0d8398e4f0a1ef3888d1204bc54381b16f'
  end

  bottle do
    sha1 "08b825b39bf16375b17cd4b4d73a95093936d41c" => :mavericks
    sha1 "1f5775826a2414f9741b90ce2c27a1c4e3a1cfe1" => :mountain_lion
    sha1 "fd95734a178d909409670ca74cb29d06e384f3db" => :lion
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
