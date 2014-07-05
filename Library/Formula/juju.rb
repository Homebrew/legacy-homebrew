require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.0/+download/juju-core_1.20.0.tar.gz'
  sha1 'f57547a0221fd3b5eb0b545c233a88999ce0dc78'

  bottle do
    revision 1
    sha1 "dc0589478813a6825e8921fccac6c3b98708ddfa" => :mavericks
    sha1 "a66e18adb8834883d83d64be67cd482e06f4a05e" => :mountain_lion
    sha1 "f7d9d80b43bdfc355d49b1576bbb15335c3330e2" => :lion
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
