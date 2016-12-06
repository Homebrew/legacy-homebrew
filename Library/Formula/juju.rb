require 'formula'

class Juju < Formula
  homepage 'http://juju.ubuntu.com/'
  url 'https://github.com/juju/juju-core/releases/download/1.11.2/macjuju-1.11.2.tar.gz'
  sha1 '9e6da291cdf30da5460b9399d0fc75215d115eb7'

  def install
    bin.install "juju"
  end
end
