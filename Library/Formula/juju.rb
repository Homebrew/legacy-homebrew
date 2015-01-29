require 'formula'

class Juju < Formula
  homepage 'https://juju.ubuntu.com'
  url 'https://launchpad.net/juju-core/1.21/1.21.1/+download/juju-1.21.1-osx.tar.gz'
  sha1 'daf84cfa532aded465b2a26a3fa11b0e2f4b1920'

  def install
    bin.install "juju", "juju-metadata"
    bash_completion.install "bash_completion.d/juju-core"
  end

  test do
    system "#{bin}/juju", "version"
  end
end
