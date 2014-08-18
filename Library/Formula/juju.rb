require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.5/+download/juju-core_1.20.5.tar.gz'
  sha1 '13761283208b6502cefd6262cb1fb5242f9e029b'

  bottle do
    sha1 "8c0220660c2bafa5783eeffbbb7e6d2139e8dcb4" => :mavericks
    sha1 "fc40f33c6ba96ab9a35259bae4bc6618f7792183" => :mountain_lion
    sha1 "64445f9c4d3019d150065b66245426f87d48540c" => :lion
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
