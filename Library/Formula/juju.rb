require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url "https://launchpad.net/juju-core/1.16/1.16.0/+download/juju-core_1.16.0.tar.gz"
  sha1 "f06321553dce389ebbc5f72786ac62a6ad43eae9"

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
