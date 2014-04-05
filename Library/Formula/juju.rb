require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.18/1.18.0/+download/juju-core_1.18.0.tar.gz'
  sha1 '48bea04a5404de900512fd6399fc8db546993eeb'

  bottle do
    sha1 "06dec5a1342231cc7721cb6afcb51ea0604ffa8c" => :mavericks
    sha1 "04c65a325c275c66b490684daca7342ef5f7220a" => :mountain_lion
    sha1 "80c65027bcb4ac3b11d39232d27171816236856a" => :lion
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
