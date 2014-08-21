require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.5/+download/juju-core_1.20.5.tar.gz'
  sha1 '13761283208b6502cefd6262cb1fb5242f9e029b'

  bottle do
    sha1 "8ad51687501185d2e1ef01465e0e8a2305f74f86" => :mavericks
    sha1 "85a825cb166251490adffaef5af8480237258547" => :mountain_lion
    sha1 "df493899e265e978b44b76b39dfe9cde431f1a62" => :lion
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
