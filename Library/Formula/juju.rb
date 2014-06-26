require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.4/+download/juju-core_1.18.4.tar.gz'
  sha1 '70ac905e113eedfa08ad8a8acab319b0c7c462cb'

  devel do
    url 'https://launchpad.net/juju-core/trunk/1.19.4/+download/juju-core_1.19.4.tar.gz'
    sha1 'bca2e5d966583797b215afcaf0de0e69d45c48bd'
  end

  bottle do
    revision 1
    sha1 "dc0589478813a6825e8921fccac6c3b98708ddfa" => :mavericks
    sha1 "a66e18adb8834883d83d64be67cd482e06f4a05e" => :mountain_lion
    sha1 "f7d9d80b43bdfc355d49b1576bbb15335c3330e2" => :lion
  end

  depends_on 'go' => :build

  def install
    ENV['GOPATH'] = buildpath
    if build.stable?
      args = %w(install launchpad.net/juju-core/cmd/juju)
    else
      args = %w(install github.com/juju/juju/cmd/juju)
    end
    args.insert(1, "-v") if ARGV.verbose?
    system "go", *args
    bin.install 'bin/juju'
    if build.stable?
      bash_completion.install "src/launchpad.net/juju-core/etc/bash_completion.d/juju-core"
    else
      bash_completion.install "src/github.com/juju/juju/etc/bash_completion.d/juju-core"
    end
  end

  test do
    system "#{bin}/juju", "version"
  end
end
