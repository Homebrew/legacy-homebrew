require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.4/+download/juju-core_1.18.4.tar.gz'
  sha1 '70ac905e113eedfa08ad8a8acab319b0c7c462cb'

  devel do
    url 'https://launchpad.net/juju-core/trunk/1.19.3/+download/juju-core_1.19.3.tar.gz'
    sha1 '9ef0ce0d8398e4f0a1ef3888d1204bc54381b16f'
  end

  bottle do
    sha1 "426a5dadbd72c7d700e35b31103aaa431a226ef7" => :mavericks
    sha1 "de572c1e63a7d2093761be983571e9f7ded6d761" => :mountain_lion
    sha1 "e238eb414e934330fb54aa7793c37cfa22ca2c5f" => :lion
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
