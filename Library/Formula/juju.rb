require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.20/1.20.6/+download/juju-core_1.20.6.tar.gz'
  sha1 '52473e72c0eb920812df587f3a3a6d3eaeb3a8a9'

  bottle do
    sha1 "d48276fb64739cae5a3b26b0f326d884764691e6" => :mavericks
    sha1 "a0617bbaade7d5ac23296af78d16deba67630d93" => :mountain_lion
    sha1 "5afd07d2ed2269077f88ca032d03ba760b55bbd1" => :lion
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
