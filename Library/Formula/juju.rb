require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url "https://launchpad.net/juju-core/1.14/1.14.0/+download/juju-core_1.14.0.tar.gz"
  sha1 "7cefd01c8edb6168e6eae4a6bb44173f61cfd356"

  depends_on 'go' => :build

  fails_with :clang do
    cause "clang: error: no such file or directory: 'libgcc.a'"
  end

  def install
    ENV['GOPATH'] = buildpath
    args = %w(install launchpad.net/juju-core/cmd/juju)
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    bin.install 'bin/juju'
  end

  def test
    system "#{bin}/juju", "version"
  end
end
